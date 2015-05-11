//
//  MenuViewController.swift
//  CourseCub
//
//  Created by Alexander Meade on 24/04/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    var carts = appDelegate.namedCarts
    let NUM_STATIC_CELLS = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        getNamedCarts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.namedCarts.count + NUM_STATIC_CELLS
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CartsLabel")
            cell.textLabel?.text = "CARTS"
            cell.userInteractionEnabled = false
            return cell
        }
            
        else if indexPath.row <= appDelegate.namedCarts.count {
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Carts")
            cell.textLabel?.text = appDelegate.namedCarts[indexPath.row - 1]
            return cell
        }
            
        else if indexPath.row == appDelegate.namedCarts.count + 1 {
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
        else if (indexPath.row <= appDelegate.namedCarts.count) {
            //switch back to the calendar view and switch to the specified cart
            switchCart()
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let calVC = sb.instantiateViewControllerWithIdentifier("cal") as! CalendarViewController
            let calNAV = sb.instantiateViewControllerWithIdentifier("calNav") as! UINavigationController
            calNAV.setViewControllers([calVC], animated: false)
            self.revealViewController().rearViewRevealOverdraw = 0;
            var rvc = self.revealViewController()
            rvc.setFrontViewController(calNAV, animated: true)
            rvc.pushFrontViewController(calNAV, animated: true)
        }
        else if (indexPath.row == appDelegate.namedCarts.count + 1) {
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
        if (indexPath.row > 1 && indexPath.row <= appDelegate.namedCarts.count) {
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
        self.carts.append("New Cart")
        self.tableView.reloadData()
    }
    
    func switchCart() {
        
    }
    
    func getNamedCarts() {
//        if appDelegate.cartsLoaded != true {
            var defaults = NSUserDefaults.standardUserDefaults()
            var termCode = defaults.objectForKey(appDelegate.COURSE_TERM_CODE) as! String
            let urlPath = "https://ords-qa.services.brown.edu:8443/pprd/banner/mobile/getNamedCarts?term=" + termCode + "&in_id=" + appDelegate.getSessionCookie()
            let url = NSURL(string: urlPath)
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
            let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
                if(error != nil) {
                    // If there is an error in the web request, print it to the console
                    println(error.localizedDescription)
                    appDelegate.cartsLoaded = false
                    return;
                } else {
                    var err: NSError?
                    
                    var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
                    if(err != nil) {
                        // If there is an error parsing JSON, print it to the console
                        println("JSON Error \(err!.localizedDescription)")
                    }
                    
                    var cartNames = JSON(jsonResult);
                    var tempCartNames = [String]()
                    
                    
                    var charset = NSCharacterSet(charactersInString: ",")
                    
                    tempCartNames.append("Current Cart")
                    for (index: String, cart: JSON) in cartNames["items"] {
                        println(cart)
                        var crn_list = cart["crn_list"].string!
                        var array = crn_list.componentsSeparatedByCharactersInSet(charset) as NSArray
                        
                        if array.count > 0 {
                            tempCartNames.append(cart["cart_name"].string!)
                        }
                    }
                    appDelegate.namedCarts = tempCartNames
                    self.tableView.reloadData()
                    return;
                }
                
            })
            
            task.resume()

//        }
    }
}
