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
    let NUM_STATIC_CELLS = 4
    var saveTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
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
//            var sCImageView = UIImageView()
//            sCImageView.image = UIImage(named: "IconWhiteBG")
//            sCImageView.frame = CGRectMake(7, 5, 45, 45)
//            cell.addSubview(sCImageView)
            cell.textLabel!.font = UIFont(name: "Avenir-Roman", size: 24)!
            cell.userInteractionEnabled = false
            cell.separatorInset = UIEdgeInsetsZero
            cell.preservesSuperviewLayoutMargins = false
            cell.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
            return cell
        }
            
            
        else if indexPath.row <= appDelegate.namedCarts.count {
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Carts")
            var offset = CGFloat(60)
            cell.textLabel!.font = UIFont(name: "Avenir-Roman", size: 20)!
            if indexPath.row != appDelegate.namedCarts.count {
                cell.separatorInset = UIEdgeInsetsMake(0, offset, 0, 0)
                cell.preservesSuperviewLayoutMargins = false
                cell.textLabel?.text = " " + appDelegate.namedCarts[indexPath.row - 1]
            }
            else {

                var name = UILabel(frame: CGRectMake(offset, 0, self.view.frame.width, 45))
                name.text = " " + appDelegate.namedCarts[indexPath.row - 1]
                name.font = UIFont(name: "Avenir-Roman", size: 20)!
                cell.addSubview(name)
                cell.separatorInset = UIEdgeInsetsZero
                cell.preservesSuperviewLayoutMargins = false
            }
            cell.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
            return cell
        }
            
        else if indexPath.row == appDelegate.namedCarts.count + 1 {
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "SaveCart")
            cell.textLabel?.text = "       Save Cart"
            var sCImageView = UIImageView()
            sCImageView.image = UIImage(named: "SaveCart")
            sCImageView.frame = CGRectMake(7, 5, 45, 45)
            cell.addSubview(sCImageView)
            cell.textLabel!.font = UIFont(name: "Avenir-Roman", size: 24)!
            cell.separatorInset = UIEdgeInsetsZero
            cell.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
            cell.preservesSuperviewLayoutMargins = false
            return cell
        }
        else if indexPath.row == appDelegate.namedCarts.count + 2 {
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Register")
            var sCImageView = UIImageView()
            cell.textLabel?.text = "       Register"
            sCImageView.image = UIImage(named: "Register")
            sCImageView.frame = CGRectMake(7, 5, 45, 45)
            cell.addSubview(sCImageView)
            cell.textLabel!.font = UIFont(name: "Avenir-Roman", size: 24)!
            cell.separatorInset = UIEdgeInsetsZero
            cell.preservesSuperviewLayoutMargins = false
            cell.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
            return cell
        }
        else {
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Settings")
            cell.textLabel?.text = "       Settings"
            var sCImageView = UIImageView()
            sCImageView.image = UIImage(named: "Settings")
            sCImageView.frame = CGRectMake(7, 5, 45, 45)
            cell.addSubview(sCImageView)
            cell.textLabel!.font = UIFont(name: "Avenir-Roman", size: 24)!
            cell.separatorInset = UIEdgeInsetsZero
            cell.preservesSuperviewLayoutMargins = false
            cell.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
            return cell
        }
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0) {
            return
        }
        else if (indexPath.row <= appDelegate.namedCarts.count) {
            //switch back to the calendar view and switch to the specified cart
            if indexPath.row == 1 {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let calVC = sb.instantiateViewControllerWithIdentifier("cal") as! CalendarViewController
                let calNAV = sb.instantiateViewControllerWithIdentifier("calNav") as! UINavigationController
                calNAV.setViewControllers([calVC], animated: false)
                self.revealViewController().rearViewRevealOverdraw = 0;
                var rvc = self.revealViewController()
                rvc.setFrontViewController(calNAV, animated: true)
                rvc.pushFrontViewController(calNAV, animated: true)
            }
            else {
                switchCart(appDelegate.namedCarts[indexPath.row - 1])
            }
        }
        else if (indexPath.row == appDelegate.namedCarts.count + 1) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            var alert : UIAlertController = UIAlertController(title: "Save Cart:", message: "If you enter an existing list name, it will be overwritten with the current cart.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
                self.saveCart(self.saveTextField.text)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            alert.addTextFieldWithConfigurationHandler { textField in
                self.saveTextField = textField!
                self.saveTextField.text = appDelegate.loadedCartName
                self.saveTextField.placeholder = "Cart Name"
            }
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else if (indexPath.row == appDelegate.namedCarts.count + 2) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            var alert : UIAlertController = UIAlertController(title: "Register:", message: "Do you want to redirect to banner?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default, handler: { alertAction in
                self.presentViewController(alert, animated: true, completion: nil)
                var url = NSURL(string: "https://bannersso.cis-qas.brown.edu/SSB_PPRD")
                UIApplication.sharedApplication().openURL(url!)
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
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
    
    func saveCart(cartName: String) {
        if cartName == "" {
            return
        }
        
        var NScartName = cartName as NSString
        let charset = NSCharacterSet(charactersInString: " ")
        let array = NScartName.componentsSeparatedByCharactersInSet(charset) as NSArray
        var cartName_final = array.componentsJoinedByString("_") as String!
        
        appDelegate.loadedCartName = cartName_final
        var replace = false
        for name in appDelegate.namedCarts {
            if name == cartName_final {
                replace = true
            }
        }
        if replace == false && appDelegate.namedCarts.count > 5 {
            let alertController = UIAlertController(title: "Too many carts:", message:
                "Delete some of your carts or overwrite an existing cart.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.Cancel, handler: {alertAction in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        if count(cartName_final) >= 11 {
            let alertController = UIAlertController(title: "Too many characters:", message:
                "Names must be less than 11 characters.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.Cancel, handler: {alertAction in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)

        }
        else {
            addCart(cartName_final)
        }
        
    }
    
    func addCart(cartName: String) {
        var crn_list = ""
        for course in appDelegate.currentCart.getCourses() {
            crn_list += (course.crn) + ","
        }
        
        var defaults = NSUserDefaults.standardUserDefaults()
        var termCode = defaults.objectForKey(appDelegate.COURSE_TERM_CODE) as! String
        let urlPath = "https://ords-qa.services.brown.edu:8443/pprd/banner/mobile/cartbyname?term=" + termCode + "&in_id=" + appDelegate.getSessionCookie() + "&cart_name=" + cartName + "&crn_list=" + crn_list + "&in_type=I"
        println("ADDINGCART")
        println(urlPath)
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
                //                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
                if(err != nil) {
                    // If there is an error parsing JSON, print it to the console
                    println("JSON Error \(err!.localizedDescription)")
                }
                self.getNamedCarts()
                return;
            }
            
        })
        
        task.resume()
    }
    
    func replaceCart(cartName: String) {
        
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
            if indexPath.row != 1 {
                var name = appDelegate.namedCarts[(indexPath.row - 1)]
                self.deleteNamedCart(name)
                appDelegate.namedCarts.removeAtIndex(indexPath.row - 1)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
        else if (editingStyle == UITableViewCellEditingStyle.Insert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

    func switchCart(name: String) {
        clearCurrentCart(name)
    }
    
    func clearCurrentCart(cartToAdd: String) {
        var crn_list = ""
        var crns = [String]()
        for course in appDelegate.currentCart.getCourses() {
            if !appDelegate.currentCart.isRegistered(course) {
                crns.append(course.crn)
            }
        }
        crn_list = ",".join(crns)
        if crn_list == "" {
            self.getCartByName(cartToAdd)
            return
        }
        
        var defaults = NSUserDefaults.standardUserDefaults()
        var termCode = defaults.objectForKey(appDelegate.COURSE_TERM_CODE) as! String
        let urlPath = "https://ords-qa.services.brown.edu:8443/pprd/banner/mobile/cartBulkDML?term=" + termCode + "&in_id=" + appDelegate.getSessionCookie() + "&crn_string=" + crn_list + "&in_type=D"
        println("DELETING")
        print (urlPath)
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
//                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
                if(err != nil) {
                    // If there is an error parsing JSON, print it to the console
                    println("JSON Error \(err!.localizedDescription)")
                }
                
                self.getCartByName(cartToAdd)
                return;
            }
            
        })
        
        task.resume()
    }
    
    
    func getCartByName(name: String) {
        var tempName = name
        var NScartName = tempName as NSString
        var charset2 = NSCharacterSet(charactersInString: " ")
        var array = NScartName.componentsSeparatedByCharactersInSet(charset2) as NSArray
        var name_final = array.componentsJoinedByString("_") as String!
        var defaults = NSUserDefaults.standardUserDefaults()
        var termCode = defaults.objectForKey(appDelegate.COURSE_TERM_CODE) as! String

        let urlPath = "https://ords-qa.services.brown.edu:8443/pprd/banner/mobile/cartbyname?term=" + termCode + "&in_id=" + appDelegate.getSessionCookie() + "&cart_name=" + name_final
        println("\nGETCARTBYNAME")
        println(urlPath)
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
                
                var cartByNameCourses = JSON(jsonResult);
                var addCrnList = cartByNameCourses["items"][0]["crn_list"].string!

                appDelegate.loadedCartName = name_final
                self.addCourses(addCrnList)
                return;
            }
            
        })
        
        task.resume()
    }
    
    func addCourses(addCourses: String) {
        var crn_list = ""
        var crns = [String]()
        for course in appDelegate.currentCart.getCourses() {
            crns.append(course.crn)
        }
        crn_list = ",".join(crns)
        
        var defaults = NSUserDefaults.standardUserDefaults()
        var termCode = defaults.objectForKey(appDelegate.COURSE_TERM_CODE) as! String
        let urlPath = "https://ords-qa.services.brown.edu:8443/pprd/banner/mobile/cartBulkDML?term=" + termCode + "&in_id=" + appDelegate.getSessionCookie() + "&crn_string=" + addCourses + "&in_type=I"
        println("ADDING")
        println(urlPath)
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
                
                if(err != nil) {
                    // If there is an error parsing JSON, print it to the console
                    println("JSON Error \(err!.localizedDescription)")
                }
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let calVC = sb.instantiateViewControllerWithIdentifier("cal") as! CalendarViewController
                let calNAV = sb.instantiateViewControllerWithIdentifier("calNav") as! UINavigationController
                calNAV.setViewControllers([calVC], animated: false)
                self.revealViewController().rearViewRevealOverdraw = 0;
                var rvc = self.revealViewController()
                rvc.setFrontViewController(calNAV, animated: true)
                rvc.pushFrontViewController(calNAV, animated: true)
                return;
            }
            
        })
        
        task.resume()
    }
    
    func deleteNamedCart(name: String) {
        var tempName = name
        var NScartName = tempName as NSString
        var charset2 = NSCharacterSet(charactersInString: " ")
        var array = NScartName.componentsSeparatedByCharactersInSet(charset2) as NSArray
        var name_final = array.componentsJoinedByString("_") as String!

        var defaults = NSUserDefaults.standardUserDefaults()
        var termCode = defaults.objectForKey(appDelegate.COURSE_TERM_CODE) as! String
        let urlPath = "https://ords-qa.services.brown.edu:8443/pprd/banner/mobile/cartbyname?term=" + termCode + "&in_id=" + appDelegate.getSessionCookie() + "&cart_name=" + name_final + "&crn_list=1&in_type=D"
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
//            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            if(err != nil) {
            // If there is an error parsing JSON, print it to the console
            println("JSON Error \(err!.localizedDescription)")
            }
            self.getNamedCarts()
            return;
        }
        
        })
        
        task.resume()

    }
    
    func getNamedCarts() {
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
                    var crn_list = cart["crn_list"].string!
                    var array = crn_list.componentsSeparatedByCharactersInSet(charset) as NSArray
                    
                    if array.count > 0 {
                        var tempName = cart["cart_name"].string!
                        var NScartName = tempName as NSString
                        var charset2 = NSCharacterSet(charactersInString: "_")
                        var array = NScartName.componentsSeparatedByCharactersInSet(charset2) as NSArray
                        var cartName_final = array.componentsJoinedByString(" ") as String!
                        tempCartNames.append(cartName_final)
                    }
                }
                appDelegate.namedCarts = tempCartNames
                self.tableView.reloadData()
                return;
            }
            
        })
        
        task.resume()

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath  indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row > 0 && indexPath.row <= appDelegate.namedCarts.count {
            return 45
        }
        return 55;
    }
}
