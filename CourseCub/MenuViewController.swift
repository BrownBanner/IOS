//
//  MenuViewController.swift
//  CourseCub
//
//  Created by Alexander Meade on 24/04/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    let COURSE_TERM_KEY = "COURSE_TERM"
    let COURSE_TERM_INDEX = "COURSE_INDEX"
    var termArray = ["Spring 2014", "Fall 2014", "Spring 2015", "Fall 2015"]
    var storedTerm = "Spring 2015"
    var storedIndex = 2
    
    @IBOutlet weak var termPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
