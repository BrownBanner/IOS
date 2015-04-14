//
//  AppDelegate.swift
//  CourseCub
//
//  Created by Cody R Fitzgerald on 2/16/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import UIKit

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let hardcoded_department_abrv = ["AFRI", "AMST", "ANTH", "APMA", "ARAB", "ARCH", "AWAS", "BEO", "BIOL", "CATL", "CHEM", "CHIN", "CLAS", "CLPS", "COLT", "CROL", "CSCI", "CZCH", "DEVL", "EAST", "ECON", "EDUC", "EGYT", "EINT", "ENGL", "ENGN", "ENVS", "ERLY", "ETHN", "FREN", "GEOL", "GISP", "GNSS", "GREK", "GRMN", "HIAA", "HISP", "HIST", "HMAN", "HNDI", "INDP", "INTL", "ITAL", "JAPN", "JUDS","KREA", "LANG", "LAST", "LATN", "LING", "LITR", "MATH", "MCM", "MDVL", "MES", "MGRK", "MUSC", "NEUR", "PHIL", "PHP", "PHYS", "PLME", "PLSH", "POBS", "POLS", "PPAI", "PRSN", "RELS", "REMS", "RUSS", "SANS", "SCSO", "SIGN", "SLAV", "SOC",  "SWED", "TAPS", "TKSH", "UNIV", "URBN", "VISA"]
    
    let hardcoded_department_title = ["Africana Studies",
                                    "American Studies",
                                    "Anthropology",
                                    "Applied Mathematics",
                                    "Arabic",
                                    "Archaeology and the Ancient World",
                                    "Ancient Western Asian Studies",
                                    "Business, Entrep. and Organ.",
                                    "Biology",
                                    "Catalan",
                                    "Chemistry",
                                    "Chinese",
                                    "Classics",
                                    "Cognitive, Linguistic, Psych Sci",
                                    "Comparative Literature",
                                    "Haitian-Creole",
                                    "Computer Science",
                                    "Czech",
                                    "Development Studies",
                                    "East Asian Studies",
                                    "Economics",
                                    "Education",
                                    "Egyptology",
                                    "English for Internationals",
                                    "English",
                                    "Engineering",
                                    "Environmental Studies",
                                    "Early Cultures",
                                    "Ethnic Studies",
                                    "French",
                                    "Geology",
                                    "Group Studies",
                                    "Gender and Secuality Studies",
                                    "Greek",
                                    "German Studies",
                                    "History of Art and Architecture",
                                    "Hispanic Studies",
                                    "History",
                                    "Humanities",
                                    "Hindu-Urdu",
                                    "Independent Studies",
                                    "Iternational Relations",
                                    "Italian",
                                    "Japanese",
                                    "Judaic Studies",
                                    "Korean",
                                    "Language Studies",
                                    "Latin American Studies",
                                    "Latin",
                                    "Linguistics",
                                    "Literary Arts",
                                    "Mathematics",
                                    "Modern Culture and Media",
                                    "Medieval Studies",
                                    "Middle East Studies",
                                    "Modern Greek",
                                    "Music",
                                    "Neuroscience",
                                    "Philosophy",
                                    "Public Health",
                                    "Physics",
                                    "Program in Liberal Med. Educ.",
                                    "Polish",
                                    "Portuguese &amp; Brazilian Studies",
                                    "Political Science",
                                    "Public Policy",
                                    "Persian",
                                    "Religious Studies",
                                    "Renaissance and Early Modern Studies",
                                    "Russian",
                                    "Sanskrit",
                                    "Science and Society",
                                    "American Sign Language",
                                    "Slavic Languages",
                                    "Sociology",
                                    "Sweedish",
                                    "Theatre Arts and Performance Studies",
                                    "Turkish",
                                    "University Courses",
                                    "Urban Studies",
                                    "Visual Art"]

    
    var department_list = [Department]()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        if (hardcoded_department_abrv.count == hardcoded_department_title.count) {
            for (var index = 0; index < hardcoded_department_abrv.count; index++) {
                var new_dep = Department()
                new_dep.abbrev = hardcoded_department_abrv[index]
                new_dep.name = hardcoded_department_title[index]
                department_list.append(new_dep)
            }
        }
        
        var cache: LocalSubstitutionCache = LocalSubstitutionCache()
        NSURLCache.setSharedURLCache(cache)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

