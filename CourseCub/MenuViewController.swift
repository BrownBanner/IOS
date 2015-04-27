//
//  MenuViewController.swift
//  CourseCub
//
//  Created by Alexander Meade on 24/04/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    var carts = [Cart]()
    let NUM_STATIC_CELLS = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carts.append(Cart(cartTitle: "Cart 1", cartCourseArray: []))
        carts.append(Cart(cartTitle: "Cart 2", cartCourseArray: []))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carts.count + NUM_STATIC_CELLS
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CartsLabel")
            cell.textLabel?.text = "CARTS"
            cell.userInteractionEnabled = false
            return cell
        }
            
        else if indexPath.row <= carts.count {
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Carts")
            cell.textLabel?.text = carts[indexPath.row - 1].title as String
            return cell
        }
            
        else if indexPath.row == carts.count + 1 {
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "AddCart")
            cell.textLabel?.text = "Add Cart"
            return cell
        }
        else {
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Settings")
            cell.textLabel?.text = "Settings"
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0) {
            return
        }
        else if (indexPath.row <= carts.count) {
            //switch back to the calendar view and switch to the specified cart
            switchCart()
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let calVC = sb.instantiateViewControllerWithIdentifier("cal") as! CalendarViewController
            let calNAV = sb.instantiateViewControllerWithIdentifier("calNav") as! UINavigationController
            calNAV.setViewControllers([calVC], animated: false)
            
            var rvc = self.revealViewController()
            rvc.setFrontViewController(calNAV, animated: true)
            rvc.pushFrontViewController(calNAV, animated: true)
        }
        else if (indexPath.row == carts.count + 1) {
            addCart()
        }
        else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let settingsVC = sb.instantiateViewControllerWithIdentifier("settings") as! SettingsViewController
            let settingsNAV = sb.instantiateViewControllerWithIdentifier("settingsNav") as! UINavigationController
            settingsNAV.setViewControllers([settingsVC], animated: false)
            
            var rvc = self.revealViewController()
            rvc.setFrontViewController(settingsNAV, animated: true)
            rvc.pushFrontViewController(settingsNAV, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (indexPath.row > 0 && indexPath.row <= carts.count) {
            return true
        }
        else {
            return false
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // Delete the row from the data source
            carts.removeAtIndex(indexPath.row - 1)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        else if (editingStyle == UITableViewCellEditingStyle.Insert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func addCart() {
        self.carts.append(Cart(cartTitle:"New Cart", cartCourseArray: []))
        self.tableView.reloadData()
    }
    
    func switchCart() {
        
    }
}
