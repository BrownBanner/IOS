//
//  LocationViewController.swift
//  CourseCub
//
//  Created by Cody R Fitzgerald on 5/4/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var Webview: UIWebView!
    
    var data = NSMutableData()
    
    var location = ""
    
    var activityIndicator:UIActivityIndicatorView? = nil
    
    // For PPRD use this
    var URLPath = "http://www.brown.edu/Facilities/Facilities_Management/maps/#building/"
    
    // For DPRD use this
    //  var URLPath = "https://dshibproxycit.services.brown.edu/SSB_DPRD"
    
    var cookie : NSHTTPCookie = NSHTTPCookie()
    
    var cookieJar : NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    
    func loadAddressURL() {
        print(URLPath as String!)
        let requestURL = NSURL(string:URLPath)
        let request = NSURLRequest(URL:requestURL!)
        Webview?.delegate = self
        Webview?.loadRequest(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        URLPath = "http://www.brown.edu/Facilities/Facilities_Management/maps/#building/" //+ location
        loadAddressURL()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(webView : UIWebView) {
    }
    
    func webViewDidFinishLoad(webView : UIWebView) {
        /*var loggedIn = webView.stringByEvaluatingJavaScriptFromString("window.location.href")
        if (loggedIn! == "https://selfservice-qas.brown.edu/ssPPRD/twbkwbis.P_GenMenu?name=bmenu.P_MainMnu") {
            webView.hidden = true;
            nextPageTest.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        }*/
    }

}
