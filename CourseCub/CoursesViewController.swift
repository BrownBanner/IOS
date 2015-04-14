//
//  CoursesViewController.swift
//  CourseCub
//
//  Created by Cody R Fitzgerald on 2/16/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import UIKit

class CoursesViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var alphabet_dict = Dictionary<String, Int>()
    var alphabet_count = [Int](count: 26, repeatedValue: 0);
    var department = ""
    var abbrev = ""
    var jsonCourseList = JSON("")
    var courseList = [Course]();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        for letter in alphabet {
            alphabet_dict[letter] = 0
        }
        
        getClassesByDepartment(self.abbrev, department: self.department)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return alphabet.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var letter = ""
        for var i = 0 ; i < alphabet.count; i++ {
            if i == section {
                letter = alphabet[i]
            }
        }
        return alphabet_dict[letter]!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        var row_increment = 0
        if (indexPath.section != 0){
            row_increment = alphabet_count[indexPath.section - 1]
        }

        var subjectParts = courseList[row_increment + indexPath.row].subjectc.componentsSeparatedByString(" ")
        var meetingParts = courseList[row_increment + indexPath.row].meeting_time.componentsSeparatedByString(" ")
        var meetingTime = meetingParts[3] + " " + meetingParts[4];
        cell.textLabel?.text = subjectParts[1] + " " + subjectParts[2] + " " + meetingTime;
        cell.detailTextLabel?.text = courseList[row_increment + indexPath.row].title;
        cell.detailTextLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        cell.detailTextLabel?.numberOfLines = 0;
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var row_increment = 0
        if (indexPath.section != 0){
            row_increment = alphabet_count[indexPath.section - 1]
        }
        
        var course  = courseList[indexPath.row + row_increment];
         var detailsCourse = CourseDetailViewController();
        detailsCourse.course = course;
        detailsCourse.navigationItem.title = course.subjectc
        self.navigationController?.pushViewController(detailsCourse, animated: true);
    }
    
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return self.alphabet
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return index
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return alphabet[section]
    }
    
    //THIS WILL BE THE API CALL
    func getClassesByDepartment(depAbbrev: String?, department: String) {
        
        //Something like this will be useful eventually
        //let searchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        //This will also be useful eventually
        //if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
        
        
        //            let urlPath = "http://blooming-bastion-7117.herokuapp.com/courses?term=201420"
        let urlPath = "https://ords-qa.services.brown.edu:8443/pprd/banner/mobile/courses?term=201420&dept=" + depAbbrev!
        let url = NSURL(string: urlPath)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
                return;
            } else {
                var err: NSError?
                
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
                if(err != nil) {
                    // If there is an error parsing JSON, print it to the console
                    println("JSON Error \(err!.localizedDescription)")
                }
                self.jsonCourseList = JSON(jsonResult)
                let count: Int? = self.jsonCourseList["items"].array?.count
                
                /*let results: NSArray = jsonResult["results"] as NSArray
                dispatch_async(dispatch_get_main_queue(), {
                self.tableData = results
                self.tableView!.reloadData()
                })*/
                
                var selectedCourses = CoursesViewController();

                for (index: String, courseJson: JSON) in self.jsonCourseList["items"] {
                    var new_course = Course(jsonCourse: courseJson)
                    self.courseList.append(new_course)
                }
                
                self.sortCourses()
                self.countSections()
                self.tableView.reloadData()
                return;
            }
            
        })
        
        task.resume()
    }
    
    
    func countSections () {
        
        for course in courseList {
            var firstLetter = course.title.substringToIndex(advance(course.title.startIndex, 1))
            if alphabet_dict[firstLetter] == nil {
                alphabet_dict[firstLetter] = 0
            } else {
                alphabet_dict[firstLetter] = 1 + alphabet_dict[firstLetter]!
            }
        }
        
        for var i = 0 ; i < alphabet.count; i++ {
            var previous = 0
            if (i != 0) {
                previous = alphabet_count[i - 1]
            }
            alphabet_count[i] = alphabet_dict[alphabet[i]]! + previous
            
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0;
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath  indexPath: NSIndexPath) -> CGFloat {
        return 60;
    }
    
    func sortCourses() {
        self.courseList.sort({ $0.subjectc < $1.subjectc })
    }
    

    
    
    /* This function is a workaround for CIS's bad SSL*/
    func URLSession(session: NSURLSession!, didReceiveChallenge challenge: NSURLAuthenticationChallenge!, completionHandler: ((NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void)!) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust && challenge.protectionSpace.host == "ords-dev.brown.edu" {
            let credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust)
            challenge.sender.useCredential(credential, forAuthenticationChallenge: challenge)
            completionHandler(.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust))
        } else {
            challenge.sender.performDefaultHandlingForAuthenticationChallenge!(challenge)
        }
        
        
    }
    
    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
    
    // Configure the cell...
    
    return cell
    }
    */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
}
