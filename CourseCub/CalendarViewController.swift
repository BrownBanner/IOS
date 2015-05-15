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
    let subBlock_color = appDelegate.colorWithHexString("#ACAEAF")//#ACAEAF
    
    let cb_height = CGFloat(10)
    let label_height = CGFloat(20)
    let margin = CGFloat(13)
    
    var blur: UIView?
    var popup: UIView?
    var calView: UIView?
    
    var conflictWindowUp = false //toggle to block calendar from refreshing until conflict popup is dismissed
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet var browseDepartments: UIBarButtonItem!
    @IBOutlet weak var cartTextField: UITextView!
    
    var cartCRNs = JSON("")
    var cartCourses = JSON("")
    
    override func viewDidAppear(animated: Bool) {
        if !conflictWindowUp{
            getCart()
        }
    }
    
    override func viewDidLoad() {
        
        conflictWindowUp = false
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
        addCalView();
        var defaults = NSUserDefaults.standardUserDefaults()
        var termArray = ["Fall 2013", "Spring 2014", "Fall 2014", "Spring 2015"]
        self.title = termArray[defaults.objectForKey(appDelegate.COURSE_TERM_INDEX) as! Int]
    }
    
    func addCalView(){
        var screenSize: CGRect = UIScreen.mainScreen().bounds
        var screenWidth = screenSize.width
        var screenHeight = screenSize.height
        calView = UIView(frame: CGRectMake(margin, margin, screenWidth-margin, screenHeight-margin))
        addHours()
        self.view.addSubview(calView!)
    }
    
    func addHours(){
        var screenSize: CGRect = UIScreen.mainScreen().bounds
        var screenWidth = screenSize.width
        var screenHeight = screenSize.height
        let minHeight = screenHeight/(1800-800)
        
        
        var hours = ["", "9", "10", "11", "12", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        var i = 0
        for hour in hours{
            var hourPoint = CGFloat(i)*(minHeight*CGFloat(60))
            var hourLabel = UILabel(frame: CGRectMake(2, hourPoint, margin, 10))
            hourLabel.font = UIFont(name: "Avenir-Roman", size: 9)
            hourLabel.text = hour
            hourLabel.textColor = text_color
            self.view.addSubview(hourLabel)
            ++i
        }
    }
    
    func addDayColumns(){
        var screenSize: CGRect = UIScreen.mainScreen().bounds
        var screenWidth = screenSize.width - margin
        var screenHeight = screenSize.height
        var day_width = screenWidth/5
        
        //So that color behind numbers matches up
        var backView = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        backView.backgroundColor = background_color_dos
        self.view.addSubview(backView)
        
        var days = ["M", "T", "W", "R", "F"]
        
        for var i = 0; i < 5; i++
        {
            var day_column = UIView(frame: CGRectMake(CGFloat(i)*day_width+margin, 0, day_width, screenHeight))
            if isEven(i){
                day_column.backgroundColor = background_color
            }else{
                day_column.backgroundColor = background_color_dos
            }
            self.view .addSubview(day_column);
            
            var dayLabelPoint = day_width/CGFloat(2)
            var dayLabel = UILabel(frame: CGRectMake(dayLabelPoint-3, 2, margin, 10))
            dayLabel.text = days[i]
            dayLabel.font = UIFont(name: "Avenir-Roman", size: 9)
            dayLabel.textColor = text_color
            day_column.addSubview(dayLabel)
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
    
    //####Cart and cal
    func getCart() {
        var defaults = NSUserDefaults.standardUserDefaults()
        var termCode = defaults.objectForKey(appDelegate.COURSE_TERM_CODE) as! String

//        let urlPath = "https://ords-qa.services.brown.edu:8443/pprd/banner/mobile/cartbyid?term=" + termCode + "&in_id=" + appDelegate.getSessionCookie()
        let urlPath = "https://ords-dev.services.brown.edu:8121/dprd/banner/mobile/cartbyid?term=" + termCode + "&in_id=" + appDelegate.getSessionCookie()
        
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
        
        
        
        var day_width = (screenWidth-margin)/5
        
        var courseArray = [String]()
        var day_dict = [String:[CCCourseButton]]()
        //Run through courses and construct initial courseblocks with data
        for (course: Course) in appDelegate.currentCart.getCourses() {
            
            courseArray += [course.crn]
            
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
                    courseBlock.cart = courseArray
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
                        day_dict[String(d)]! += [courseBlock]
                    }else{
                        day_dict[String(d)] = [courseBlock]
                    }
                    
                    //Add to view
                    calView!.addSubview(courseBlock)
                    
                }
            }
        }
        //Run through days, find conflicts and add courseblocks to screen
        for day in day_letters{
            if let d = find(day_letters, day){
                if day_dict[String(d)] == nil{
                }else{
                    var courseblock_array_for_day = day_dict[String(d)]
                    for courseBlock in courseblock_array_for_day!{
                        var curConflictArray = [courseBlock]//Create conflict array for current courseblock
                        for block in courseblock_array_for_day!{
                            if courseBlock.startTime >= block.startTime && courseBlock.startTime <= block.stopTime{
                                block.conflict = true
                                if !contains(curConflictArray, block){
                                    curConflictArray.append(block)
                                }
                            }
                        }
                        //Conflict array constructed now update courseblock to account for conflicts
                        if curConflictArray.count>1{
                            var i = 0
                            var j = 0
                            //Get leftmost block to add text to without overlay
                            
                            var leftMostBlock = CCCourseButton?()
                            var minStart = 100000
                            var maxStop = 0
                            for courseBlock in curConflictArray{//Find min start time and max stop time
                                if j == 0{
                                    leftMostBlock = courseBlock
                                }else{
                                    for view in courseBlock.subviews{
                                        println(getClassName(view))
                                        if getClassName(view) == "UILabel"{
                                            view.removeFromSuperview()
                                        }
                                    }
                                }
                                if courseBlock.startTime<minStart{
                                    minStart = courseBlock.startTime!
                                }
                                if courseBlock.stopTime>maxStop{
                                    maxStop = courseBlock.stopTime!
                                }
                                ++j
                                
                                //Reset target
                                courseBlock.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
                                courseBlock.addTarget(self, action: "displayConflictPopUp:", forControlEvents: UIControlEvents.TouchUpInside)
                                
                                courseBlock.conflictArray = []
                                for b in curConflictArray{
                                    courseBlock.conflictArray?.append(b.course!)
                                }
                            }
                            
                            //Calculate overall block dimensions
                            var overallStartPoint = CGFloat(minStart-800)
                            var overallStartOffset = CGFloat(overallStartPoint*minHeight)
                            var overallDuration = minHeight*CGFloat(maxStop-minStart)
                            
                            for courseBlock in curConflictArray{
                                //Add coursebuttons to courseButtonArray
//                                if !contains(courseBlock.conflictArray!, [courseBlock.course]){
//                                    courseBlock.conflictArray += [courseBlock.course]
//                                }
//                                for block in curConflictArray{
//                                    if !contains(courseBlock.conflictArray?, block.course?){
//                                        courseBlock.conflictArray += [block.course]
//                                    }
//                                }
                                
                                //Split the block
                                var count = curConflictArray.count
                                var width = Int(day_width)/(count)
                                var x_offset = i * width
                                var d_offset = Int(day_width)*d
                                
                                var start_point = CGFloat(courseBlock.startTime!-800)
                                var duration = minHeight*CGFloat(courseBlock.stopTime!-courseBlock.startTime!)
                                var min_offset = minHeight*start_point
                                
                                println(CGFloat(d_offset)+CGFloat(x_offset))
                                
                                courseBlock.frame = CGRectMake(CGFloat(d_offset)+CGFloat(x_offset), overallStartOffset, CGFloat(width), overallDuration)
                                courseBlock.color_bumper?.frame = CGRectMake(0, 0, CGFloat(width), cb_height)
                                courseBlock.color_bumper!.subviews.map({ $0.removeFromSuperview() })
                                courseBlock.addCrossHatch(courseBlock.color_bumper!)
                                
                                //Display indicator subblocks
                                var subBlock = UIView(frame: CGRectMake(0, min_offset-overallStartOffset, CGFloat(width), duration))
                                subBlock.backgroundColor = subBlock_color.colorWithAlphaComponent(0.1)
                                subBlock.userInteractionEnabled = false
                                courseBlock.addSubview(subBlock)
                                
                                //List the text
                                if courseBlock.frame.height > (label_height+20)*CGFloat(i){
                                    var y_text_offset = i*20
                                    courseBlock.course_label?.frame = CGRectMake(2-CGFloat(x_offset), cb_height+CGFloat(y_text_offset), day_width, label_height)
                                    courseBlock.course_label?.textColor = blue
                                    
                                    var courseLabelText = courseBlock.course_label?.text
                                    courseBlock.course_label?.removeFromSuperview()
                                    var coursesNotDisplayed = String(count-i-1)
                                    
                                    var newCourseLabel = UILabel(frame: CGRectMake(2, cb_height+CGFloat(y_text_offset), day_width, label_height))
                                    if coursesNotDisplayed == "0"{
                                        if courseBlock.frame.height > (label_height+20)*CGFloat(i+1){newCourseLabel.text = courseLabelText}else{newCourseLabel.text = courseLabelText!}
                                    }else{
                                        if courseBlock.frame.height > (label_height+20)*CGFloat(i+1){newCourseLabel.text = courseLabelText}else{newCourseLabel.text = courseLabelText! + " +" + coursesNotDisplayed}
                                    }
                                    newCourseLabel.font = UIFont(name: "Avenir-Roman", size: 10)
                                    newCourseLabel.textColor = text_color
                                    leftMostBlock?.addSubview(newCourseLabel)
                                    
                                }
                                
                                
                                
                                i = i+1
                                
                                courseBlock.bringSubviewToFront(courseBlock.color_bumper!)
                                self.view.bringSubviewToFront(leftMostBlock!)
                            }
                            
                        }
                        curConflictArray = []
                        courseBlock.conflict = false
                    }
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
        if(sender.conflict){
            displayConflictPopUp(sender)
        }else{
            //Get Course
            var course = sender.course
            
            //Send user to course detail page
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let detailsCourse = sb.instantiateViewControllerWithIdentifier("courseDetail") as! CourseDetailViewController
            detailsCourse.course = course!;
            detailsCourse.navigationItem.title = course!.subjectc
            self.navigationController?.pushViewController(detailsCourse, animated: true)
        }
    }
    
    func conflictPressed(sender:CCCourseButton!){
            //Get Course
            var course = sender.course
            
            //Send user to course detail page
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let detailsCourse = sb.instantiateViewControllerWithIdentifier("courseDetail") as! CourseDetailViewController
            detailsCourse.course = course!;
            detailsCourse.navigationItem.title = course!.subjectc
            self.navigationController?.pushViewController(detailsCourse, animated: true)
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
    
    func getClassName(obj : AnyObject) -> String
    {
        let objectClass : AnyClass! = object_getClass(obj)
        let className = objectClass.description()
        
        return className
    }
    
    func displayConflictPopUp(sender: CCCourseButton){
        conflictWindowUp = true
        println("Display conflict popup")
        blur = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        blur!.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        let image = UIImage(named: "lightg.png")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        imageView.alpha = 0.2
        blur!.addSubview(imageView)
        self.view.addSubview(blur!)
        
        popup = UIView(frame: CGRectMake(45, 100, 300, 300))
        popup!.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        var conflictLabel = UILabel(frame: CGRectMake(0, 10, popup!.frame.width, 30))
        conflictLabel.textAlignment = NSTextAlignment.Center
        conflictLabel.textColor = UIColor.whiteColor()
        conflictLabel.font = UIFont(name: "Avenir-Roman", size: 30)
        conflictLabel.text = "Conflict"
        popup!.addSubview(conflictLabel)
        blur!.addSubview(popup!)
        
        var xImage = UIImage(named: "CancelX")
        var xImageWhite = colorizeWith(xImage!, color: UIColor.whiteColor())
        let xImageView = UIImageView(image: xImageWhite)
        xImageView.frame = CGRectMake(15, 15, 20, 20)
        var cancelButton = UIButton(frame: CGRectMake(0, 0, 35, 35))
        cancelButton.addSubview(xImageView)
        cancelButton.addTarget(self, action: "dismissPopUp", forControlEvents: UIControlEvents.TouchUpInside)
        popup!.addSubview(cancelButton)
        
        displayConflictsOnPopup(sender)
    }
    
    func dismissPopUp(){
        blur!.removeFromSuperview()
        conflictWindowUp = false
        getCart()//Refresh calendar
    }
    
    func displayConflictsOnPopup(sender: CCCourseButton){
        println(sender.conflictArray)
        var i = 0
        var headerMargin = CGFloat(60)
        for course in sender.conflictArray!{
            
            var conflictButton = CCCourseButton(frame: CGRectMake(10, headerMargin+CGFloat(i*40), popup!.frame.width, 35))
            conflictButton.course = course
            conflictButton.addTarget(self, action: "conflictPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            popup?.addSubview(conflictButton)
            
            var conflictLabel = UILabel(frame: CGRectMake(10, headerMargin+CGFloat(i*40), popup!.frame.width, 35))
            conflictLabel.text = course.subjectc
            conflictLabel.textColor = UIColor.whiteColor()
            conflictLabel.font = UIFont(name: "Avenir-Roman", size: 20)
            popup?.addSubview(conflictLabel)
            
            var timeLabel = UILabel(frame: CGRectMake(popup!.frame.width-118, headerMargin+CGFloat(i*40), popup!.frame.width, 35))
            var meetingParts = course.meeting_time.componentsSeparatedByString(" ")
            timeLabel.text = meetingParts[3] + " " + meetingParts[4]
            timeLabel.textColor = UIColor.whiteColor()
            timeLabel.font = UIFont(name: "Avenir-Roman", size: 12)
            popup?.addSubview(timeLabel)
            
            var arrowImage = UIImage(named: "Rarrow")
            var arrowImageWhite = colorizeWith(arrowImage!, color: UIColor.whiteColor())
            let arrowImageView = UIImageView(image: arrowImageWhite)
            arrowImageView.frame = CGRectMake(popup!.frame.width-30, headerMargin+CGFloat(i*40)+8, 20, 20)
            popup!.addSubview(arrowImageView)
            
            ++i
        }
    }
    
    func colorizeWith(image: UIImage, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        CGContextTranslateCTM(context, 0, image.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        
        // set the blend mode to color burn, and the original image
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        let rect = CGRectMake(0, 0, image.size.width, image.size.height);
        CGContextDrawImage(context, rect, image.CGImage);
        
        // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
        CGContextClipToMask(context, rect, image.CGImage);
        CGContextAddRect(context, rect);
        CGContextDrawPath(context,kCGPathFill);
        
        // generate a new UIImage from the graphics context we drew onto
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //return the color-burned image
        return coloredImage;
    }

}