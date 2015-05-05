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
    
    override func viewDidAppear(animated: Bool) {
        getCart()
        
    }
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
        
        //#######Calendar Body
        addCourseBlocks();
    }
    
    func addCourseBlocks(){
//        
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
        var day_letters = ["M","T","W","R","F"]
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let minHeight = screenHeight/(1800-800)
        
        let blue = appDelegate.colorWithHexString("#3498db")//#3498db
        let grey = appDelegate.colorWithHexString("#bdc3c7")//#bdc3c7
        
        var day_width = screenWidth/5
        
        for (course: Course) in appDelegate.currentCart.getCourses() {
            //Get Course Info
            var meetingParts = course.meeting_time.componentsSeparatedByString(" ")
            println(meetingParts)
            //Time
            var start_stop_array = meetingParts[4].componentsSeparatedByString("-")
            var start_time = start_stop_array[0].toInt()!
            var stop_time = start_stop_array[1].toInt()!
            //Day
            var days_array = Array(meetingParts[3])
            
            
            //Course time info to pixel data
            var start_point = CGFloat(start_time-800)
            var duration = minHeight*CGFloat(stop_time-start_time)
            var min_offset = minHeight*start_point
            
            //Day to pixels
            var day_num = CGFloat(0);
            for day in days_array{
                if let d = find(day_letters, String(day))
                {
                    println(d)
                    var day_num = CGFloat(d)
                    var day_offset = day_width * day_num
                    
                    //Create courseBlock
                    var courseBlock = UIView(frame: CGRectMake(day_offset, min_offset, day_width, duration))
                    courseBlock.backgroundColor=grey
                    //Create color bumbper
                    var color_bumper = UIView(frame: CGRectMake(0, 0, day_width, 10))
                    color_bumper.backgroundColor=blue
                    courseBlock.addSubview(color_bumper);
                    //Add to view
                    self.view.addSubview(courseBlock)
                    
                }
            }
        }

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