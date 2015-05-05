//
//  DepartmentViewController.swift
//  CourseCub
//
//  Created by Cody R Fitzgerald on 2/16/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import UIKit

var dep_list = appDelegate.department_list

class DepartmentViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, NSURLSessionDelegate, UISearchResultsUpdating {
    var alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
    var alphabet_dict = Dictionary<String, Int>()
    var alphabet_count = [Int](count: 26, repeatedValue: 0);
    
    var searchResults = [String]()
    var resultSearchController = UISearchController()
    
    
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
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        // Reload the table
        self.tableView.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
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
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        self.tableView.reloadData()
        self.tableView.becomeFirstResponder()
    }
  
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
        cell.textLabel?.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1);
        cell.detailTextLabel?.text = dep_list[row_increment + indexPath.row].name;
        cell.detailTextLabel?.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 0.6);
        cell.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1);
        cell.textLabel?.font = UIFont(name: "Avenir-Roman", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Avenir-Roman", size: 14)
        
        //Fill this in for searching
        if (self.resultSearchController.active) {
            //cell.textLabel?.text = ""
        }
        
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

        let sb = UIStoryboard(name: "Main", bundle:nil)
        let selectedCourses = sb.instantiateViewControllerWithIdentifier("coursesViewController") as! CoursesViewController
        selectedCourses.department = department;
        selectedCourses.abbrev = abbrev!;
        selectedCourses.navigationItem.title = abbrev!;
        self.navigationController?.pushViewController(selectedCourses, animated: true);

    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return alphabet[section]
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        //searchResults.removeAll(keepCapacity: false)
        
        //Fill this in for searching
        
        self.tableView.reloadData()
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
