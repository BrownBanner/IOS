//
//  CCCourseButton.swift
//  
//
//  Created by Noah Fradin on 5/11/15.
//
//

import UIKit

class CCCourseButton: UIButton {
    
    let cb_height = CGFloat(10)
    let label_height = CGFloat(20)
    
    let text_color = appDelegate.colorWithHexString("#666666")//#666666
    
    let blue = appDelegate.colorWithHexString("#3498db")//#3498db
    let purple = appDelegate.colorWithHexString("#9b59b6")//#9b59b6
    let 🌻 = appDelegate.colorWithHexString("#f1c40f")//#FCFBF7
    let green = appDelegate.colorWithHexString("#2ecc71")//#2ecc71
    let red  = appDelegate.colorWithHexString("#e74c3c")//#e74c3c
    let 🐢 = appDelegate.colorWithHexString("#1abc9c")//#1abc9c
    let 🌞 = appDelegate.colorWithHexString("#f39c12")//#f39c12
    
    var cart: [String]?
    var course: Course?
    var conflict: Bool = false
    var meetingTime: String?
    var startTime: Int?
    var stopTime: Int?
    var duration: Int?
    var courseCode: String?
    var conflictArray: [Course]?
    
    var color_bumper: UIView?
    var course_label: UILabel?
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Call to populate button properties with computable course data
    func populateData() {
        if course != nil{
            meetingTime = course?.meeting_time
            var meetingParts = meetingTime?.componentsSeparatedByString(" ")
            
            //Times
            var start_stop_array = meetingParts?[4].componentsSeparatedByString("-")
            startTime = start_stop_array?[0].toInt()
            stopTime = start_stop_array?[1].toInt()
            duration = stopTime!-startTime!
            
            //CourseCode
            var subjectc_array = course!.subjectc.componentsSeparatedByString(" ")
            courseCode = subjectc_array[0]+subjectc_array[1]
            addBumper(getBumperColor(course!))
        }
    }
    
    func getBumperColor(course: Course)->UIColor{
        if let c = find(cart!, course.crn){
            var color_array = [🌻, blue, purple, green, red, 🐢,🌞]
            return color_array[c]
        }
        else{
            return blue;
        }
    }
    func addBumper(color: UIColor){
        
        color_bumper = UIView(frame: CGRectMake(0, 0, self.frame.width, cb_height))
        color_bumper!.backgroundColor=color
        self.addSubview(color_bumper!)
    }
    func addCourseLabel(){
        course_label = UILabel(frame: CGRectMake(2, cb_height, self.frame.width, label_height))
        course_label?.textColor = text_color
        course_label?.font = UIFont(name: "Avenir-Roman", size: 10)
        course_label?.text = courseCode
        self.addSubview(course_label!);
    }
    func addCourseLabelWithTextAndFrame(cc: String, f: CGRect){
        course_label = UILabel(frame: f)
        course_label?.textColor = text_color
        course_label?.font = UIFont(name: "Avenir-Roman", size: 11)
        course_label?.text = cc
        self.addSubview(course_label!);
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
