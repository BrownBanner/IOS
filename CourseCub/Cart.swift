//
//  Cart.swift
//  CourseCub
//
//  Created by Noah Fradin on 2/25/15.
//  Copyright (c) 2015 Noah Fradin. All rights reserved.
//

import Foundation

class Cart {
    var title: NSString;//User generated name of course (Can differ from name on )
    var synced: Bool;//Set to true when any changes on the device side cart have been passed up to banner
    var courseArray: [Course];
    
    init (cartTitle: String, cartCourseArray: [Course]) {
        if(cartTitle != NSNull()){
            self.title = cartTitle
        }else{
            self.title = "Default Cart"
        }
        if(cartCourseArray != NSNull()) {
            self.courseArray = cartCourseArray
        } else {
            self.courseArray = [Course]()
        }
        synced = true;
        
    }
    
    /**
        Get list of courses in cart
    
        :returns: List of courses in cart
    */
    func getCourses() -> [Course]{
        return courseArray;
    }
    
    /**
        Adds courses to cart's course list
    
        :param: Array of courses to add to cart
    */
    func setCourses(courses: [Course]){
        courseArray = [Course]()
        for course in courses{
            addCourse(course)
        }
    }
    
    func addCourse(course: Course) -> Bool{
        if cartContains(course) != true {
            courseArray.append(course)
            return true
        }
        return false
    }
    
    func cartContains(course: Course) -> Bool {
        for cartCourse in courseArray {
            if cartCourse.crn == course.crn {
                return true
            }
        }
        return false
    }
    
    func isRegistered(course: Course) -> Bool {
        for cartCourse in courseArray {
            if cartCourse.crn == course.crn {
                if (cartCourse.reg_indicator == "Y") {
                    return true
                }
            }
        }
        return false
    }
    
    /**
        Checks if you can add courses to cart
    
        :param: Array of courses to test
    
        :returns: Boolean for whether or not it's kosher to add to cart
    */
    func canAdd(courses: [Course])->Bool{
        if(underCourseLimit()){
            for course in courses{
                if(!underSeatLimit(course)){
                    return false;
                }
            }
            return true//If all under seat limit and cart is under course limit
        }else{
            return false;
        }
    }
    
    /**
        Checks if number of courses in list of courses is under course limit
    
        :returns: Boolean for whether or not array of courses is under course number limit
    */
    func underCourseLimit() ->Bool{
        if(courseArray.count<6){
            return true
        }else{
            return false
        }
    }
    
    /**
        Checks if registration for course is under capacity
    
        :param: Course to check if there are spots open for
    
        :returns: Boolean for whether there are seats open or not (true = under limit and false = at limit)
    */
    func underSeatLimit(course: Course)->Bool{
        //TODO: Return true if registered students +  is under number
        if (course.numStudentsAllowed > course.numStudentsRegistered) {
            return true
        }
        else {
            return false
        }
    }
    
}