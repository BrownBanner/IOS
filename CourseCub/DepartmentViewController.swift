
//
//  DepartmentViewController.swift
//  CourseCub
//
//  Created by Cody R Fitzgerald on 2/16/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import UIKit

var dep_list = appDelegate.department_list

class DepartmentViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, NSURLSessionDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    var alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
    var alphabet_dict = Dictionary<String, Int>()
    var alphabet_count = [Int](count: 26, repeatedValue: 0);
    var jsonSearchList = JSON("")
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    var resultSearchController = UISearchController()
    
    
    @IBOutlet var tView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultSearchController.searchBar.hidden = false
        appDelegate.searchResults.removeAll(keepCapacity: false)
        
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "department")
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        for letter in alphabet {
            alphabet_dict[letter] = 0
        }
        
        self.spinner.center = CGPointMake(self.view.frame.width / 2, 60)
        self.spinner.hidesWhenStopped = true;
        self.view.addSubview(spinner)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.9411, green: 0.3254, blue: 0.3254, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.9411, green: 0.3254, blue: 0.3254, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.translucent = false;
        
        self.view.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
        tableView.sectionIndexBackgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
        tableView.sectionIndexColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1);
        
        var backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton;
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 20)!]
        
    
        
        countSections()
        
             println ("BUG")
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.barTintColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
            controller.searchBar.layer.borderWidth = 1
            controller.searchBar.layer.borderColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1).CGColor
            controller.searchBar.layer.shadowColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1).CGColor
            controller.searchBar.delegate = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.definesPresentationContext = true
            self.tableView.tableHeaderView = controller.searchBar

            return controller
        })()
        // Reload the table
        self.tableView.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println ("WILLL")

        
        appDelegate.searchResults.removeAll(keepCapacity: false)
        if (appDelegate.clickedSearchCourse == true) {
            self.resultSearchController.searchBar.text = appDelegate.searchTextSave
            //self.resultSearchController.active = true
            //self.resultSearchController.searchBar.becomeFirstResponder()
            //self.resultSearchController.active = true
            appDelegate.clickedSearchCourse = false
        }
        else {
            tableView.reloadData()
        }
        self.resultSearchController.searchBar.hidden = false

        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if (appDelegate.clickedSearchCourse == false) {
//            self.resultSearchController.active = false
//        }
//    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if (appDelegate.clickedSearchCourse == false) {
            /*if (self.resultSearchController.active) {
                print("Here")
                self.resultSearchController.active = false
            }*/
        }
        //self.resultSearchController.searchBar.text = ""
        self.resultSearchController.searchBar.resignFirstResponder()
        self.resultSearchController.searchBar.hidden = true

        
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
        return alphabet.count
        //}
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //if (self.resultSearchController.active) {
        //    return self.searchResults.count
        //}
        //else {
        var letter = ""
        for var i = 0 ; i < alphabet.count; i++ {
            if i == section {
                letter = alphabet[i]
            }
        }
        return alphabet_dict[letter]!
        // }
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
        if self.resultSearchController.active {
            return nil
        }
        else {
            return self.alphabet

        }
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
        
        /*if (appDelegate.clickedSearchCourse == true) {
        self.resultSearchController.active = true
        }*/
        
        if (self.resultSearchController.active) {
            if (appDelegate.searchResults.count <= 0) {
                cell.textLabel?.text = nil
                cell.detailTextLabel?.text = nil
            }
            else {
                var subjectParts = appDelegate.searchResults[row_increment + indexPath.row].subjectc.componentsSeparatedByString(" ")
                var meetingParts = appDelegate.searchResults[row_increment + indexPath.row].meeting_time.componentsSeparatedByString(" ")
                var meetingTime = meetingParts[3] + " " + meetingParts[4];
                cell.detailTextLabel?.text = subjectParts[1] + " " + subjectParts[2] + " " + meetingTime;
                cell.textLabel?.text = appDelegate.searchResults[row_increment + indexPath.row].title;
                cell.detailTextLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping;
                cell.detailTextLabel?.numberOfLines = 0;
                cell.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1);
                cell.textLabel?.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1);
                cell.detailTextLabel?.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 0.6);
                
                cell.textLabel?.font = UIFont(name: "Avenir-Roman", size: 18)
                cell.detailTextLabel?.font = UIFont(name: "Avenir-Roman", size: 14)
                
            }
            
        }
            
        else {
            cell.textLabel?.text = dep_list[row_increment + indexPath.row].abbrev;
            cell.textLabel?.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1);
            cell.detailTextLabel?.text = dep_list[row_increment + indexPath.row].name;
            cell.detailTextLabel?.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 0.6);
            cell.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1);
            cell.textLabel?.font = UIFont(name: "Avenir-Roman", size: 18)
            cell.detailTextLabel?.font = UIFont(name: "Avenir-Roman", size: 14)
            
        }
        
        //Fill this in for searching
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let abbrev = cell?.textLabel?.text!
        var department = "Test Department";
        
        if (resultSearchController.active) {
            var row_increment = 0
            if (indexPath.section != 0){
                row_increment = alphabet_count[indexPath.section - 1]
            }
            
            var course  = appDelegate.searchResults[indexPath.row + row_increment];
            appDelegate.clickedSearchCourse = true
            appDelegate.searchTextSave = resultSearchController.searchBar.text
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let detailsCourse = sb.instantiateViewControllerWithIdentifier("courseDetail") as! CourseDetailViewController
            detailsCourse.course = course;
            detailsCourse.navigationItem.title = course.subjectc
            self.navigationController?.pushViewController(detailsCourse, animated: true)
            
        }
            
        else {
            
            for item in dep_list {
                if (item.abbrev == abbrev!) {
                    department = item.name;
                }
            }
            
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let selectedCourses = sb.instantiateViewControllerWithIdentifier("coursesViewController") as! CoursesViewController
            selectedCourses.department = department;
            selectedCourses.abbrev = abbrev!;
            selectedCourses.navigationItem.title = abbrev!;
            self.navigationController?.pushViewController(selectedCourses, animated: true);
        }
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return alphabet[section]
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        appDelegate.searchResults.removeAll(keepCapacity: false)
        countSections()
        tableView.reloadData()
        
        search(searchController.searchBar.text)
        countSections()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        appDelegate.searchTextSave = ""
        appDelegate.searchResults.removeAll(keepCapacity: false)
        tableView.reloadData()
        countSections()
        
        
    }
    
    
    func search (searchTerm: String) {
        
        var defaults = NSUserDefaults.standardUserDefaults()
        var termCode = defaults.objectForKey(appDelegate.COURSE_TERM_CODE) as! String
        if (searchTerm == "") {
            return;
        }
        var newSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let urlPath = "http://blooming-bastion-7117.herokuapp.com/search?term=201420&num_results=20&search=" + newSearchTerm
        let url = NSURL(string: urlPath)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        self.spinner.startAnimating()
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
                self.jsonSearchList = JSON(jsonResult)
                let count: Int? = self.jsonSearchList["items"].array?.count
                
                //var selectedCourses = CoursesViewController();
                for (index: String, courseJson: JSON) in self.jsonSearchList["items"] {
                    var new_course = Course(jsonCourse: courseJson)
                    appDelegate.searchResults.append(new_course)
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
    
    
    
    //Check the first letters of each item in the departmentAbbrevArray, change the letter to a number corresponding to the section numbers, and then use those numbers to count the number of items in each alphabetical section. UGH.
    func countSections () {
        alphabet_dict = Dictionary<String, Int>()
        alphabet_count = [Int](count: 26, repeatedValue: 0);
        for letter in alphabet {
            alphabet_dict[letter] = 0
        }
        
        if (self.resultSearchController.active) {
            
            for course in appDelegate.searchResults {
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
            
        else {
            
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
    }
    
    
    func sortCourses() {
        appDelegate.searchResults.sort({ $0.title < $1.title })
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

