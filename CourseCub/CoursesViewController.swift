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
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    @IBOutlet var advancedSearchCourse: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        for letter in alphabet {
            alphabet_dict[letter] = 0
        }
        
        self.spinner.center = CGPointMake(self.view.frame.width / 2, 20)
        self.spinner.hidesWhenStopped = true;
        self.view.addSubview(spinner)
        spinner.startAnimating()
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

    func getClassesByDepartment(depAbbrev: String?, department: String) {
        

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
                
                
                var selectedCourses = CoursesViewController();

                for (index: String, courseJson: JSON) in self.jsonCourseList["items"] {
                    var new_course = Course(jsonCourse: courseJson)
                    self.courseList.append(new_course)
                }
                
                self.sortCourses()
                self.countSections()
                self.spinner.stopAnimating()
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

}
