//
//  AppDelegate.swift
//  CourseCub
//
//  Created by Cody R Fitzgerald on 2/16/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//


//TODO:
//Pull to refresh

import UIKit

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //These constants pertain to setting the term for the courses
    let COURSE_TERM_KEY = "COURSE_TERM"
    let COURSE_TERM_INDEX = "COURSE_INDEX"
    let COURSE_TERM_CODE = "COURSE_CODE"
    var storedIndex = 2
    var storedTerm = "Spring 2015"
    var storedCode = "201420"
    var currentCart = Cart(cartTitle: "", cartCourseArray: [Course]())
    var namedCarts = [String]()
    var cartsLoaded = false

    let hardcoded_department_abrv = [
        "AFRI",
        "AMST",
        "ANTH",
        "APMA",
        "ARCH",
        "BEO",
        "BIOL",
        "BIOM",
        "BMED",
        "CHEM",
        "CLAS",
        "CLPS",
        "COGT",
        "COLT",
        "COMP",
        "CRET",
        "DEVL",
        "EAST",
        "ECON",
        "EDUC",
        "EEPS",
        "EGYA",
        "EGYT",
        "ENGL",
        "ENGN",
        "ENVS",
        "ERLY",
        "FREN",
        "GEOL",
        "GRMN",
        "HIAA",
        "HISP",
        "HIST",
        "IBES",
        "INTL",
        "ITAL",
        "JUDS",
        "LANG",
        "LAST",
        "LITA",
        "MATH",
        "MCMD",
        "MDVL",
        "MES",
        "MUSC",
        "NEUR",
        "PEMB",
        "PHIL",
        "PHP",
        "PHYS",
        "PLCY",
        "POBS",
        "POLS",
        "PPAI",
        "RELS",
        "RENS",
        "SLAV",
        "SOC",
        "THTA",
        "URBN",
        "VISA"]
    
    let hardcoded_department_title = [
            "Africana Studies",
            "American Studies",
            "Anthropology",
            "Applied Mathematics",
            "Inst for Arch and Anct World",
            "Business, Entrep. & Organiz.",
            "Biology",
            "Bio-Med",
            "Bio-Med",
            "Chemistry",
            "Classics",
            "Cognitive,Linguistic,Psych Sci",
            "Cogut Center for Humanities",
            "Comparative Literature",
            "Computer Science",
            "Center for Race and Ethnicity",
            "Development Studies",
            "East Asian Studies",
            "Economics",
            "Education",
            "Earth, Environ. & Planetary Sc",
            "Egyptology & Assyriology",
            "Egyptology and Anct W. Asia St",
            "English",
            "Engineering",
            "Environmental Studies",
            "Early Cultures",
            "French Studies",
            "Geological Sciences",
            "German Studies",
            "History of Art and Architectur",
            "Hispanic Studies",
            "History",
            "Inst. Brown for Env. and Soc.",
            "International Relations",
            "Italian Studies",
            "Judaic Studies",
            "Center for Language Studies",
            "Latin Americn & Caribbean Stdy",
            "Literary Arts",
            "Mathematics",
            "Modern Culture and Media",
            "Medieval Studies",
            "Middle East Studies",
            "Music",
            "Neuroscience",
            "Pembroke Cntr Teach and Rsrch",
            "Philosophy",
            "Public Health",
            "Physics",
            "Public Policy",
            "Portuguese and Brazilian Stu",
            "Political Science",
            "Public Policy and Amer Instns",
            "Religious Studies",
            "Renaissance Studies",
            "Slavic Studies",
            "Sociology",
            "Theatre Arts & Performance Stu",
            "Urban Studies",
            "Visual Art"
    ]

    
    var department_list = [Department]()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        print (hardcoded_department_abrv.count == hardcoded_department_title.count)
        if (hardcoded_department_abrv.count == hardcoded_department_title.count) {
            for (var index = 0; index < hardcoded_department_abrv.count; index++) {
                var new_dep = Department()
                new_dep.abbrev = hardcoded_department_abrv[index]
                new_dep.name = hardcoded_department_title[index]
                department_list.append(new_dep)
            }
        }
        
        setDefaults()
        
        var cache: LocalSubstitutionCache = LocalSubstitutionCache()
        NSURLCache.setSharedURLCache(cache)
        

        
        //UIBarButtonItem.appearance().setBackButtonBackgroundImage(self.backbutton!.resizableImageWithCapInsets(UIEdgeInsetsMake(5, 0, 0, 5)), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        
        
        
        return true
    }
    
    func getSessionCookie() -> String {
        var cookie : NSHTTPCookie = NSHTTPCookie()
        var cookieJar : NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        var cookies = cookieJar.cookiesForURL(NSURL(string: "https://bannersso.cis-qas.brown.edu/SSB_PPRD")!) as! [NSHTTPCookie]
        
        for cookie in cookies {
            if (cookie.name == "IDMSESSID") {
//                return cookie.value!
                return "100463816"
            }
        }
//        return "null"
        return "100463816"
    }
    
    func setDefaults() {
        
        var defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey(COURSE_TERM_KEY) == nil {
            defaults.setObject(storedTerm, forKey: COURSE_TERM_KEY)
            defaults.setObject(storedIndex, forKey: COURSE_TERM_INDEX)
            defaults.setObject(storedCode, forKey: COURSE_TERM_CODE)
            defaults.synchronize()
        }
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
    
    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(advance(cString.startIndex, 1))
        }
        
        if (count(cString) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }


}

