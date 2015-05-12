//
//  CoursesViewController.swift
//  CourseCub
//
//  Created by Cody R Fitzgerald on 2/16/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import UIKit

class CoursesViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating  {
    

    var department = ""
    var abbrev = ""
    var jsonCourseList = JSON("")
    var courseList = [Course]();
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var searchResults = [Course]()
    var resultSearchController = UISearchController()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        self.spinner.center = CGPointMake(self.view.frame.width / 2, 60)
        self.spinner.hidesWhenStopped = true;
        self.view.addSubview(spinner)
        spinner.startAnimating()
        getClassesByDepartment(self.abbrev, department: self.department)
        
        self.view.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
        tableView.sectionIndexBackgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
        tableView.sectionIndexColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1);
        
        var backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton;
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 20)!]
        

        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.barTintColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
            controller.searchBar.layer.borderWidth = 1
            controller.searchBar.layer.borderColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1).CGColor
            controller.searchBar.layer.shadowColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1).CGColor
            controller.hidesNavigationBarDuringPresentation = false
            controller.searchBar.placeholder = "Filter Courses"
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()

        // Reload the table
        //self.tableView.reloadData()

    
    }
    
    /*override func viewWillAppear(animated: Bool) {
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.hidesNavigationBarDuringPresentation = false
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        self.tableView.reloadData()
        self.tableView.becomeFirstResponder()
    }*/
    
    
    override func viewWillDisappear(animated: Bool) {
        self.resultSearchController.resignFirstResponder()
        self.resultSearchController.searchBar.resignFirstResponder()
        self.resultSearchController.active = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        //if (self.resultSearchController.active) {
        //    return 1
        //}
        //else {
        
        return 1
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        if (self.resultSearchController.active) {
            return self.searchResults.count
        }
        else {
            return courseList.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        var course: Course
        if (self.resultSearchController.active) {
            course =  searchResults[indexPath.row]
        }
        else {
            course = courseList[indexPath.row]
        }
        
        var subjectParts = course.subjectc.componentsSeparatedByString(" ")
        var meetingParts = course.meeting_time.componentsSeparatedByString(" ")
        var meetingTime = meetingParts[3] + " " + meetingParts[4];
         cell.detailTextLabel?.text = subjectParts[1] + " " + subjectParts[2] + " " + meetingTime;
        cell.textLabel?.text = course.title;

        cell.detailTextLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        cell.detailTextLabel?.numberOfLines = 0;

        if (appDelegate.currentCart.cartContains(course)) {
            cell.backgroundColor = UIColor(red: 0.9411, green: 0.3254, blue: 0.3254, alpha: 0.8)
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.detailTextLabel?.textColor = UIColor.whiteColor()
        }
        else {
            cell.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1);
            cell.textLabel?.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1);
            cell.detailTextLabel?.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 0.6);
        }

        
        cell.textLabel?.font = UIFont(name: "Avenir-Roman", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Avenir-Roman", size: 14)
        
        //Fill this in for searching
        if (self.resultSearchController.active) {
           // cell.textLabel?.text = ""
        }
        
        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        searchResults.removeAll(keepCapacity: false)
        
        let charset = NSCharacterSet(charactersInString: " ")
        let array = resultSearchController.searchBar.text.componentsSeparatedByCharactersInSet(charset) as NSArray
        
        for course in courseList {
            var wordInFilter = true
            for word in array {
                var containsPart = false
                if (course.title.rangeOfString(word as! String, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) != nil) {
                    containsPart = true
                }
                if (course.subjectc.rangeOfString(word as! String, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) != nil)  {
                    containsPart = true
                }
                if (course.instructor.rangeOfString(word as! String, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) != nil)  {
                    containsPart = true
                }
                if (course.meeting_time.rangeOfString(word as! String, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) != nil)  {
                    containsPart = true
                }
                
                wordInFilter = containsPart
                if wordInFilter == false {
                    break;
                }
            }
            if wordInFilter {
                searchResults.append(course)
            }
        }
        
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var course: Course
        if (self.resultSearchController.active) {
            course = self.searchResults[indexPath.row]
        }
        else {
            course  = courseList[indexPath.row];
        }
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailsCourse = sb.instantiateViewControllerWithIdentifier("courseDetail") as! CourseDetailViewController
        detailsCourse.course = course;
        detailsCourse.navigationItem.title = course.subjectc
        self.navigationController?.pushViewController(detailsCourse, animated: true)
    }
    
    


    func getClassesByDepartment(depAbbrev: String?, department: String) {
        
        
        var defaults = NSUserDefaults.standardUserDefaults()
        var termCode = defaults.objectForKey(appDelegate.COURSE_TERM_CODE) as! String
        let urlPath = "https://ords-qa.services.brown.edu:8443/pprd/banner/mobile/courses?term=" + termCode + "&dept=" + depAbbrev!
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
                self.spinner.stopAnimating()
                self.tableView.reloadData()
                return;
            }
            
        })
        
        task.resume()
    }
    
    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0;
//    }
    
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
