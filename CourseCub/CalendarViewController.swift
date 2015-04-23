//
//  CalendarViewController.swift
//  CourseCub
//
//  Created by Brown Loaner on 4/17/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import Foundation
import UIKit

class CalendarViewController: UIViewController {
    
    @IBOutlet var carts: UIBarButtonItem!
    @IBOutlet var browseDepartments: UIBarButtonItem!
    override func viewDidLoad() {
        getCart()
        var backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton;
    }
    
    func getSessionCookie() -> String {
        var cookie : NSHTTPCookie = NSHTTPCookie()
        var cookieJar : NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        var cookies = cookieJar.cookiesForURL(NSURL(string: "https://bannersso.cis-qas.brown.edu/SSB_PPRD")!) as! [NSHTTPCookie]
        
        for cookie in cookies {
            if (cookie.name == "IDMSESSID") {
                print(cookie.value)
                return cookie.value!
            }
        }
        return "null"
    }
    
    func getCart() {

        let urlPath = "https://ords-qa.services.brown.edu:8443/pprd/banner/mobile/cartbyid?term=201420&in_id=" + getSessionCookie()
        let url = NSURL(string: urlPath)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
                return;
            } else {
                var err: NSError?
                
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
                if(err != nil) {
                    // If there is an error parsing JSON, print it to the console
                    println("JSON Error \(err!.localizedDescription)")
                }
                print(JSON(jsonResult))
                return;
            }
            
        })
        
        task.resume()
    }
    
    
    /* This function is a workaround for CIS's bad SSL*/
    func URLSession(session: NSURLSession!, didReceiveChallenge challenge: NSURLAuthenticationChallenge!, completionHandler: ((NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void)!) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust && challenge.protectionSpace.host == "ords-dev.brown.edu" {
            let credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust)
            challenge.sender.useCredential(credential, forAuthenticationChallenge: challenge)
            completionHandler(.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust))
        } else {
            challenge.sender.performDefaultHandlingForAuthenticationChallenge!(challenge)
        }
        
        
    }
}