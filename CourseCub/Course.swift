//
//  Course.swift
//  CourseCub
//
//  Created by Alexander Meade on 2/16/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import Foundation

class Course {
    var crn: NSString;
    var title: String;
    var description: String;
    var course_preview: String;
    var critical_review: String;
    var subjectc: String;
    var term_desc: NSString;
    var term: NSString;
    var dept: NSString;
    var location: NSString;
    var meeting_time: String;
    //var description: NSString;
    var instructor: NSString;
    var booklist: NSString;
    //var course_links: [String: String];
    
    var numStudentsRegistered: Int; //number of students registered
    var numStudentsAllowed: Int; //number of students allowed
    
    init (jsonCourse: JSON) {
        if jsonCourse["crn"] != nil {
            crn = jsonCourse["crn"].string!
        } else {
            //log some error
            crn = "error"
        }
        
        if jsonCourse["course_preview"] != nil {
            course_preview = jsonCourse["course_preview"].string!
        } else {
            //log some error
            course_preview = "error"
        }
        
        if jsonCourse["critical_review"] != nil {
            critical_review = jsonCourse["critical_review"].string!
        } else {
            //log some error
            critical_review = "error"
        }
        
        
        
        if jsonCourse["description"] != nil {
            description = jsonCourse["description"].string!
        } else {
            //log some error
            description = "error"
        }
        
        if jsonCourse["term_desc"] != nil {
            term_desc = jsonCourse["tdesc"].string!
        } else {
            //log some error
            term_desc = "error"
        }
        
        if jsonCourse["dept"] != nil {
            dept = jsonCourse["dept"].string!
        } else {
            //log some error
            dept = "error"
        }
        
        if jsonCourse["term"] != nil {
            term = jsonCourse["term"].string!
        } else {
            //log some error
            term = "error"
        }
        
        if jsonCourse["title"] != nil {
            title = jsonCourse["title"].string!
        } else {
            //log some error
            title = "error"
        }
        
        if jsonCourse["subjectc"] != nil {
            subjectc = jsonCourse["subjectc"].string!
        } else {
            //log some error
            subjectc = "error"
        }
        
        if jsonCourse["meetinglocation"] != nil {
            location = jsonCourse["meetinglocation"].string!
        } else {
            //log some error
            location = "error"
        }
        
        if jsonCourse["meetingtime"] != nil {
            meeting_time = jsonCourse["meetingtime"].string!
        } else {
            //log some error
            meeting_time = "error"
        }
        
        if jsonCourse["instructor"] != nil {
            instructor = jsonCourse["instructor"].string!
        } else {
            //log some error
            instructor = "error"
        }
        
        if jsonCourse["booklist"] != nil {
            booklist = jsonCourse["booklist"].string!
        } else {
            //log some error
            booklist = "error"
        }
        
        if jsonCourse["maxregallowed"] != nil {
            numStudentsAllowed = jsonCourse["maxregallowed"].int!
        } else {
            //log some error
            numStudentsAllowed = 1
        }
        
        if jsonCourse["actualreg"] != nil {
            numStudentsRegistered = jsonCourse["actualreg"].int!
        } else {
            //log some error
            numStudentsRegistered = 1
        }
        
        
        //description = jsonCourse["desc"].string!
        //course_links = jsonCourse["tdesc"].string!
    }
}
