//
//  DepartmentViewController.swift
//  CourseCub
//
//  Created by Cody R Fitzgerald on 2/16/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import UIKit

class AdvancedSearchDepartments: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    var alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
    var alphabet_dict = Dictionary<String, Int>()
    var alphabet_count = [Int](count: 26, repeatedValue: 0);
    
    
    @IBOutlet var tView: UITableView!
    @IBOutlet var advancedSearch: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return self.alphabet
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return index
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        var row_increment = 0
        if (indexPath.section != 0){
            row_increment = alphabet_count[indexPath.section - 1]
        }
        
        cell.textLabel?.text = dep_list[row_increment + indexPath.row].abbrev;
        cell.detailTextLabel?.text = dep_list[row_increment + indexPath.row].name;
        
        var searchSwitch = UISwitch(frame: CGRectMake(self.view.frame.width - 80, 5, 30, 20))
        
        cell.contentView.addSubview(searchSwitch);
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
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
