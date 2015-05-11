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
    
    var webViewLoads = 0
    
    var final_loc = ""
    
    var activityIndicator:UIActivityIndicatorView? = nil
    
    // For PPRD use this
    var URLPath = "http://www.brown.edu/Facilities/Facilities_Management/maps/#building/"
    
    // For DPRD use this
    //  var URLPath = "https://dshibproxycit.services.brown.edu/SSB_DPRD"
    
    var cookie : NSHTTPCookie = NSHTTPCookie()
    
    var cookieJar : NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    
    func loadAddressURL() {
        let requestURL = NSURL(string:URLPath)
        let request = NSURLRequest(URL:requestURL!)
        Webview?.delegate = self
        Webview?.loadRequest(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var NSlocation = location as NSString
        let charset = NSCharacterSet(charactersInString: "0123456789()")
        let array = NSlocation.componentsSeparatedByCharactersInSet(charset) as NSArray
        final_loc = array.componentsJoinedByString("") as String!
        final_loc = final_loc.stringByReplacingOccurrencesOfString("&", withString: "and", options: NSStringCompareOptions.LiteralSearch, range: nil)
        URLPath = "http://www.brown.edu/Facilities/Facilities_Management/m/index.php" //+ location
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
        if webViewLoads == 0 {
            let a = Webview.stringByEvaluatingJavaScriptFromString("document.getElementById('searchbtn').childNodes[0].click();")
            let b = Webview.stringByEvaluatingJavaScriptFromString("document.getElementById('btnsearch').click();")
            
        }
        else if webViewLoads == 1 {
            let c = Webview.stringByEvaluatingJavaScriptFromString("document.getElementById('txtsearch').value = '" + final_loc + "';")
            let d = Webview.stringByEvaluatingJavaScriptFromString("window.searchlist();")
        }
        webViewLoads = webViewLoads + 1

    }

}
