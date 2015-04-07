//
//  DepartmentViewController.swift
//  CourseCub
//
//  Created by Cody R Fitzgerald on 2/16/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import UIKit

var dep_list = appDelegate.department_list

class DepartmentViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, NSURLSessionDelegate {
    var courseList = JSON("")
    var alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
    var alphabet_dict = Dictionary<String, Int>()
    var alphabet_count = [Int](count: 26, repeatedValue: 0);
    
    
    @IBOutlet var tView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "department")
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        for letter in alphabet {
            alphabet_dict[letter] = 0
        }
        
        countSections()
        
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
                    
                    var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                    if(err != nil) {
                        // If there is an error parsing JSON, print it to the console
                        println("JSON Error \(err!.localizedDescription)")
                    }
                    self.courseList = JSON(jsonResult)
                    let count: Int? = self.courseList["items"].array?.count
                
                    /*let results: NSArray = jsonResult["results"] as NSArray
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableData = results
                        self.tableView!.reloadData()
                    })*/
                    
                    var selectedCourses = CoursesViewController();
                    var selected_course_list = [Course]();
                    
                    for (index: String, courseJson: JSON) in self.courseList["items"] {
                        var new_course = Course(jsonCourse: courseJson)
                        selected_course_list.append(new_course)
                    }
                    selectedCourses.courseList = selected_course_list;
                    selectedCourses.navigationItem.title = department;
                    self.navigationController?.pushViewController(selectedCourses, animated: true);
                    return;
                }

            })
        
            task.resume()
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
    
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return self.alphabet
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return index
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        var row_increment = 0
        if (indexPath.section != 0){
            row_increment = alphabet_count[indexPath.section - 1]
        }
        
        cell.textLabel?.text = dep_list[row_increment + indexPath.row].abbrev;
        cell.detailTextLabel?.text = dep_list[row_increment + indexPath.row].name;
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let abbrev = cell?.textLabel?.text!
        var department = "Test Department";
        
        for item in dep_list {
            if (item.abbrev == abbrev!) {
                department = item.name;
            }
        }

        getClassesByDepartment(abbrev, department: department);
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return alphabet[section]
    }
    
    //Check the first letters of each item in the departmentAbbrevArray, change the letter to a number corresponding to the section numbers, and then use those numbers to count the number of items in each alphabetical section. UGH.
    func countSections () {
        
        for department in dep_list {
            var firstLetter = department.abbrev.substringToIndex(advance(department.abbrev.startIndex, 1))
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
        if (section == 0) {
            return 0
        } else {
            if (alphabet_count[section] == 0) {
                return 0
            }
            else if (section > 1) {
                if (alphabet_count[section] == alphabet_count[section - 1]) {
                    return 0
                }
            }
            return 20
        }
        
    }
}
