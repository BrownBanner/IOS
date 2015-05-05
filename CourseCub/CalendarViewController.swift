//
//  CalendarViewController.swift
//  CourseCub
//
//  Created by Brown Loaner on 4/17/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import Foundation
import UIKit

class CalendarViewController: UIViewController {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet var browseDepartments: UIBarButtonItem!
    @IBOutlet weak var cartTextField: UITextView!
    
    var cartCRNs = JSON("")
    var cartCourses = JSON("")
    
    override func viewDidLoad() {
        
        
        var backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton;
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealOverdraw = 0;
        }
        
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.9411, green: 0.3254, blue: 0.3254, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.9411, green: 0.3254, blue: 0.3254, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.translucent = false;
        
        self.view.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
    }

    override func viewDidAppear(animated: Bool) {
        getCart()

    }
    
    
    func getCart() {
        var defaults = NSUserDefaults.standardUserDefaults()
        var termCode = defaults.objectForKey(appDelegate.COURSE_TERM_CODE) as! String
        
        let urlPath = "https://ords-qa.services.brown.edu:8443/pprd/banner/mobile/cartbyid?term=" + termCode + "&in_id=" + appDelegate.getSessionCookie()
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
                
                self.cartCRNs = JSON(jsonResult);
                var tempCart = [Course]()
                for (index: String, cartItem: JSON) in self.cartCRNs["items"] {
                    var tempCourse = Course(jsonCourse: cartItem)
                    tempCart.append(tempCourse)
                }
                appDelegate.currentCart.setCourses(tempCart)
                self.refreshCalendar()
                return;
            }
            
        })
        
        task.resume()
    }
    
    func refreshCalendar() {
        self.cartTextField.text = ""
        for (course: Course) in appDelegate.currentCart.getCourses() {
            self.cartTextField.text =  self.cartTextField.text + "\n" + course.title + " Registered: " + course.reg_indicator + "\n"
        }
        self.cartTextField.reloadInputViews()

    }
    
    func getCourse(courseCRN: JSON) {
        let cartCourse = Course(jsonCourse: courseCRN)
        
        
        var defaults = NSUserDefaults.standardUserDefaults()
        var termCode = defaults.objectForKey(appDelegate.COURSE_TERM_CODE) as! String
        let urlPath = "https://ords-qa.services.brown.edu:8443/pprd/banner/mobile/courses?term=" + termCode + "&crn=" + cartCourse.crn
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
                
                print(JSON(jsonResult));
              
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
}