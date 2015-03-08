//
//  CourseDetailViewController.swift
//  CourseCub
//
//  Created by Cody R Fitzgerald on 2/16/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import UIKit

class CourseDetailViewController: UIViewController  {
    
    var course: Course?
    
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classTime: UILabel!
    @IBOutlet weak var classRoom: UILabel!
    @IBOutlet weak var professor: UILabel!
    @IBOutlet weak var seatNum: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var courseDetails: UILabel!
    @IBOutlet weak var crn: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Populates all UILabels with data
        className.text = course?.title
        classTime.text = course?.time_stamp
        classRoom.text = course?.location
        professor.text = course?.professor
        courseDetails.text = course?.description
        crn.text = course?.crn
        //TODO: seats avilable and seats registered (not sure how we want to display yet)
        //TODO: Registered or not for each user (need to model user first)
        
        

        // Do any additional setup after loading the view.
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
