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
    var department: NSString;
    var location: NSString;
    var time_stamp: NSString;
    var description: NSString;
    var professor: NSString;
    var booklist: [NSString];
    var course_links: [String: String];
    
    var numStudentsRegistered: NSInteger; //number of students registered
    var numStudentsAllowed: NSInteger; //number of students allowed
    
    init (courseDict: NSDictionary) {
        crn = courseDict.objectForKey("crn")! as NSString
        title = courseDict.objectForKey("title")! as NSString
        department = courseDict.objectForKey("department")! as NSString
        location = courseDict.objectForKey("location")! as NSString
        time_stamp = courseDict.objectForKey("time_stamp")! as NSString
        description = courseDict.objectForKey("description")! as NSString
        professor = courseDict.objectForKey("professor")! as NSString
        booklist = courseDict.objectForKey("booklist")! as [NSString]
        course_links = courseDict.objectForKey("course_links")! as[String: String];
        
        numStudentsRegistered  = courseDict.objectForKey("registered")! as NSInteger;
        numStudentsAllowed  = courseDict.objectForKey("allowed")! as NSInteger;
    }
}
