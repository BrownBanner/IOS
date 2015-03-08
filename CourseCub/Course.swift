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
    var title: NSString;
    var term_desc: NSString;
    var term: NSString;
    var dept: NSString;
    var location: NSString;
    var meeting_time: NSString;
    //var description: NSString;
    var instructor: NSString;
    var booklist: NSString;
    //var course_links: [String: String];
    
    var numStudentsRegistered: NSInteger; //number of students registered
    var numStudentsAllowed: NSInteger; //number of students allowed
    
    init (jsonCourse: JSON) {
        if jsonCourse["crn"] != nil {
            crn = jsonCourse["crn"].string!
        } else {
            //log some error
            crn = "error"
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
