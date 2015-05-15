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
    let c1 = appDelegate.colorWithHexString("#34495e")//#1ABc9c
    let c2 = appDelegate.colorWithHexString("#e67e22")//#1ABc9c
    let c3 = appDelegate.colorWithHexString("#762f00")//#1ABc9c
    let c4 = appDelegate.colorWithHexString("#16A085")//#1ABc9c
    let c5 = appDelegate.colorWithHexString("#27ae60")//#1ABc9c
    let c6 = appDelegate.colorWithHexString("#2980b9")//#1ABc9c
    let c7 = appDelegate.colorWithHexString("#8e44ad")//#1ABc9c
    let c8 = appDelegate.colorWithHexString("#2c3e50")//#1ABc9c
    let c9 = appDelegate.colorWithHexString("#c0392b")//#1ABc9c
    let c10 = appDelegate.colorWithHexString("#bdc3c7")//#1ABc9c
    let c11 = appDelegate.colorWithHexString("#7f8c8d")//#1ABc9c
    let c12 = appDelegate.colorWithHexString("#d35400")//#1ABc9c
    let c13 = appDelegate.colorWithHexString("#f62459")//#1ABc9c
    
    
    
    
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
            var color_array = [🌻, blue, purple, green, red, 🐢,🌞, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10,c11, c12, c13]
            return color_array[c]
        }
        else{
            return blue;
        }
    }
    func addBumper(color: UIColor){
        
        color_bumper = UIView(frame: CGRectMake(0, 0, self.frame.width, cb_height))
        if course!.reg_indicator == "Y"{
            color_bumper!.backgroundColor=color
        }else{
            let lines = UIImage(named: "lines.png")
            let crossHatch = UIImageView(image:lines)
            crossHatch.frame = CGRectMake(0, 0, self.frame.width, cb_height)
            crossHatch.alpha = 0.3
            color_bumper!.addSubview(crossHatch)
            color_bumper!.backgroundColor=color.colorWithAlphaComponent(0.6)
        }
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
