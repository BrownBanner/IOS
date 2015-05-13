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
    
    let blue = appDelegate.colorWithHexString("#3498db")//#3498db
    let text_color = appDelegate.colorWithHexString("#666666")//#666666
    
    var course: Course?
    var conflict: Bool = false
    var meetingTime: String?
    var startTime: Int?
    var stopTime: Int?
    var courseCode: String?
    
    var color_bumper: UIView?
    var course_label: UILabel?
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        addBumper(blue)
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
            
            //CourseCode
            var subjectc_array = course!.subjectc.componentsSeparatedByString(" ")
            courseCode = subjectc_array[0]+subjectc_array[1]
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
        course_label?.font = UIFont(name: "Avenir-Roman", size: 13)
        course_label?.text = courseCode
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
