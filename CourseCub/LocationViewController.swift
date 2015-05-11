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
    var firstLoad = true
    var secondLoad = false
    
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

        if (firstLoad == true){
            let a = Webview.stringByEvaluatingJavaScriptFromString("document.getElementById('searchbtn').childNodes[0].click();")
            let b = Webview.stringByEvaluatingJavaScriptFromString("document.getElementById('btnsearch').click();")

            firstLoad = false
            secondLoad = true
        }
        else if (secondLoad) {
            
            var setToRemove = NSCharacterSet(charactersInString: "0123456789")
            var setToKeep = setToRemove.invertedSet
        
            var newString = "".join((location.componentsSeparatedByCharactersInSet(setToRemove)))
            let c = Webview.stringByEvaluatingJavaScriptFromString("document.getElementById('txtsearch').value = '" + newString + "';")

            let d = Webview.stringByEvaluatingJavaScriptFromString("window.searchlist();")
            /*var loggedIn = webView.stringByEvaluatingJavaScriptFromString("window.location.href")
            if (loggedIn! == "https://selfservice-qas.brown.edu/ssPPRD/twbkwbis.P_GenMenu?name=bmenu.P_MainMnu") {
                webView.hidden = true;
                nextPageTest.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
            }*/
            secondLoad = false
        }
    }

}
