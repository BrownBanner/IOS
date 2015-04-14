//
//  CourseDetailViewController.swift
//  CourseCub
//
//  Created by Cody R Fitzgerald on 2/16/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import UIKit

class CourseDetailViewController: UIViewController  {

    var course = Course(jsonCourse: JSON(""));
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Populates all UILabels with data
        
        var meetingParts = course.meeting_time.componentsSeparatedByString(" ")
        
        var titleLabel = UILabel(frame: CGRectMake(10, 40, self.view.frame.size.width - 20, 100))
        titleLabel.text = course.title as String
        self.view.addSubview(titleLabel)
        
        var meetingLabel = UILabel(frame: CGRectMake(10, 60, self.view.frame.size.width - 20, 100))
        meetingLabel.text = meetingParts[3] + " " + meetingParts[4]
        self.view.addSubview(meetingLabel)
        
        var instructorLabel = UILabel(frame: CGRectMake(10, 100, self.view.frame.size.width - 20, 100))
        instructorLabel.text = course.instructor as String
        self.view.addSubview(instructorLabel)
        
        var seatsLabel = UILabel(frame: CGRectMake(10, 120, self.view.frame.size.width - 20, 100))
        seatsLabel.text = String(course.numStudentsRegistered) + " / " + String(course.numStudentsAllowed);
        self.view.addSubview(seatsLabel)
        
        var locationLabel = UILabel(frame: CGRectMake(10, 140, self.view.frame.size.width - 20, 100))
        locationLabel.text = course.location as String
        self.view.addSubview(locationLabel)
        
        var coursePreviewLink = UIButton()
        
        var coursePreview = UIButton(frame: CGRectMake(10, 180, self.view.frame.size.width - 20, 40))
        coursePreview.setTitle("Course Preview", forState: UIControlState.Normal)
        coursePreview.addTarget(self, action: "viewCoursePreview:", forControlEvents: UIControlEvents.TouchUpInside)
        coursePreview.backgroundColor = UIColor.blueColor()
        self.view.addSubview(coursePreview)
        
        var criticalReview = UIButton(frame: CGRectMake(10, 220, self.view.frame.size.width - 20, 40))
        criticalReview.setTitle("Critical Review", forState: UIControlState.Normal)
        criticalReview.addTarget(self, action: "viewCriticalReview:", forControlEvents: UIControlEvents.TouchUpInside)
        criticalReview.backgroundColor = UIColor.redColor()
        self.view.addSubview(criticalReview)
        
        var bookList = UIButton(frame: CGRectMake(10, 260, self.view.frame.size.width - 20, 40))
        bookList.setTitle("Book List", forState: UIControlState.Normal)
        bookList.addTarget(self, action: "viewBookList:", forControlEvents: UIControlEvents.TouchUpInside)
        bookList.backgroundColor = UIColor.greenColor()
        self.view.addSubview(bookList)
        
        var descriptionLabel = UILabel(frame: CGRectMake(10, 280, self.view.frame.size.width - 20, 400))
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        descriptionLabel.text = course.description as String
        
        self.view.addSubview(descriptionLabel)
        self.view.backgroundColor = UIColor.whiteColor()
        
        

    }
    
    func viewCoursePreview(sender:UIButton!) {
        
    }
    
    func viewCriticalReview(sender:UIButton!) {
        
    }
    
    func viewBookList(sender:UIButton!) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
