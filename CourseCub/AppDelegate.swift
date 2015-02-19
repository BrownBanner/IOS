//
//  AppDelegate.swift
//  CourseCub
//
//  Created by Cody R Fitzgerald on 2/16/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import UIKit

let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let hardcoded_department_abrv = ["AFRI", "AMST", "ANTH", "APMA", "ARAB", "ARCH", "AWAS", "BEO", "BIOL", "CATL", "CHEM", "CHIN", "CLAS", "CLPS", "COLT", "CROL", "CSCI", "CZCH", "DEVL", "EAST", "ECON", "EDUC", "EGYT", "EINT", "ENGL", "ENGN", "ENVS", "ERLY", "ETHN", "FREN", "GEOL", "GISP", "GNSS", "GREK", "GRMN", "HIAA", "HISP", "HIST", "HMAN", "HNDI", "INDP", "INTL", "ITAL", "JAPN", "JUDS","KREA", "LANG", "LAST", "LATN", "LING", "LITR", "MATH", "MCM", "MDVL", "MES", "MGRK", "MUSC", "NEUR", "PHIL", "PHP", "PHYS", "PLME", "PLSH", "POBS", "POLS", "PPAI", "PRSN", "RELS", "REMS", "RUSS", "SANS", "SCSO", "SIGN", "SLAV", "SOC",  "SWED", "TAPS", "TKSH", "UNIV", "URBN", "VISA"]

    
    var department_list = [Department]()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        for dep in hardcoded_department_abrv {
            var new_dep = Department()
            new_dep.abbrev = dep
            department_list.append(new_dep)
        }
        
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

