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
    
    let blue = appDelegate.colorWithHexString("#3498db")//#3498db
    let purple = appDelegate.colorWithHexString("#9b59b6")//#9b59b6
    let yellow = appDelegate.colorWithHexString("#f1c40f")//#FCFBF7
    let grey = appDelegate.colorWithHexString("#DEE1E2")//#bdc3c7
    let text_color = appDelegate.colorWithHexString("#666666")//#666666
    let background_color = appDelegate.colorWithHexString("#F9F8F4")//#F9F8F4
    let background_color_dos = appDelegate.colorWithHexString("#FCFBF7")//#FCFBF7
    
    
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
        
//        self.view.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
        
        //#######Calendar Body
        addDayColumns();
    }
    
    func getCart() {
        var defaults = NSUserDefaults.standardUserDefaults()
        var termCode = defaults.objectForKey(appDelegate.COURSE_TERM_CODE) as! String
        let urlPath = "https://ords-dev.services.brown.edu:8121/dprd/banner/mobile/cartbyid?term=201420&in_id=100463816"
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
        
        
        
        var day_width = screenWidth/5
        
        var day_dict = [String:[CCCourseButton]]()
        for (course: Course) in appDelegate.currentCart.getCourses() {
            //Get Course Info
            var meetingParts = course.meeting_time.componentsSeparatedByString(" ")
            
            //Time
            var start_stop_array = meetingParts[4].componentsSeparatedByString("-")
            var start_time = start_stop_array[0].toInt()!
            var stop_time = start_stop_array[1].toInt()!
            //Day
            var days_array = Array(meetingParts[3])
            //Course Code
            var subjectc_array = course.subjectc.componentsSeparatedByString(" ")
            var course_code = subjectc_array[0]+subjectc_array[1]
            
            //Course time info to pixel data
            var start_point = CGFloat(start_time-800)
            var duration = minHeight*CGFloat(stop_time-start_time)
            var min_offset = minHeight*start_point
            //Day to pixels
            var day_num = CGFloat(0);
            for day in days_array{
                if let d = find(day_letters, String(day))
                {
                    //Add course times to times dict
                    var day_num = CGFloat(d)
                    var day_offset = day_width * day_num
                    
                    //Create courseBlock
                    var courseBlock = CCCourseButton(frame: CGRectMake(day_offset, min_offset, day_width, duration))
                    courseBlock.course = course
                    courseBlock.populateData()
                    courseBlock.addCourseLabel()
                    courseBlock.addTarget(self, action: "courseBlockPressed:", forControlEvents: UIControlEvents.TouchUpInside)
                    courseBlock.backgroundColor=grey
                    
                    //Create color bumbper
                    let cb_height = CGFloat(10)
                    
                    //Create Courselabel
                    let label_height = CGFloat(20)
                    
                    if day_dict[String(d)] != nil{//Check other classes on same day for conflict
                        var curConflictArray: [CCCourseButton]?
                        curConflictArray = [courseBlock]
                        for block in day_dict[String(d)]!{//Check if startTime of new block is greater than any older start times and lower than any older stop times -> update to create split
                            if courseBlock.startTime >= block.startTime && courseBlock.startTime <= block.stopTime{
                                println("Adding conflict")
                                block.conflict = true
                                curConflictArray?.append(block)
                                if !contains(curConflictArray!, courseBlock) {
                                    courseBlock.conflict = true
                                    curConflictArray!.append(courseBlock)
                                }
                            }
                            if curConflictArray?.count>1{
                                var i = 0
                                for courseBlock in curConflictArray!{
                                    println("Getting in here")
                                    
                                    //Split the block
                                    var count = curConflictArray!.count
                                    var width = Int(day_width)/(count+1)
                                    var x_offset = i * width
                                    courseBlock.frame = CGRectMake(day_offset+CGFloat(x_offset), min_offset, CGFloat(width), duration)
                                    courseBlock.addBumper(yellow)//Set after reset width of block because width of bumper is dependent
                                    
                                    //List the text
                                    var y_text_offset = i*20
                                    println("Yup")
                                    println(y_text_offset)
                                    courseBlock.course_label?.frame = CGRectMake(2, cb_height+CGFloat(y_text_offset), day_width, label_height)
                                    courseBlock.course_label?.textColor = blue
                                    i++
                                }
                            }

                        }
                    }else{
                        day_dict[String(d)] = [courseBlock]
                    }
                    
                    //Add to view
                    self.view.addSubview(courseBlock)
                    
                }
            }
        }

    }
   
    /**
    This the method that gets run when a user taps on a course in the calendar.
    If conflict -> call to handle conflict
    Else -> go straight to detail view
    
    @param CCCourseButton
    
    @return Nada, zip, zilch
    */
    func courseBlockPressed(sender:CCCourseButton!){
        println("Test")
//        if(sender.conflict){
//            
//        }else{
            //Get Course
            var course = sender.course
            
            //Send user to course detail page
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let detailsCourse = sb.instantiateViewControllerWithIdentifier("courseDetail") as! CourseDetailViewController
            detailsCourse.course = course!;
            detailsCourse.navigationItem.title = course!.subjectc
            self.navigationController?.pushViewController(detailsCourse, animated: true)
//        }
    }
    
//    func getCourse(courseCRN: JSON) {
//        let cartCourse = Course(jsonCourse: courseCRN)
//        
//        
//        var defaults = NSUserDefaults.standardUserDefaults()
//        var termCode = defaults.objectForKey(appDelegate.COURSE_TERM_CODE) as! String
//        let urlPath = "https://ords-qa.services.brown.edu:8443/pprd/banner/mobile/courses?term=" + termCode + "&crn=" + cartCourse.crn
//        let url = NSURL(string: urlPath)
//        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
//        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
//            if(error != nil) {
//                // If there is an error in the web request, print it to the console
//                println(error.localizedDescription)
//                return;
//            } else {
//                var err: NSError?
//                
//                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
//                if(err != nil) {
//                    // If there is an error parsing JSON, print it to the console
//                    println("JSON Error \(err!.localizedDescription)")
//                }
//                
//                print(JSON(jsonResult));
//              
//                return;
//            }
//            
//        })
//        
//        task.resume()
//    }
    
    
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
    
    func addDayColumns(){
        var screenSize: CGRect = UIScreen.mainScreen().bounds
        var screenWidth = screenSize.width
        var screenHeight = screenSize.height
        var day_width = screenWidth/5
        
        for var i = 0; i < 5; i++
        {
            var day_column = UIView(frame: CGRectMake(CGFloat(i)*day_width, 0, day_width, screenHeight))
            if isEven(i){
                day_column.backgroundColor = background_color
            }else{
                day_column.backgroundColor = background_color_dos
            }
            self.view .addSubview(day_column);
        }
    }
    
    func isEven(n:Int) -> Bool {
        
        // Bitwise check
        if (n & 1 != 0) {
            return false
        }
        
        // Mod check
        if (n % 2 != 0) {
            return false
        }
        return true
    }
}