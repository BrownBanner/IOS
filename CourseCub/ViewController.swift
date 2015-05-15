//
//  ViewController.swift
//  CourseCub
//
//  Created by Cody R Fitzgerald on 2/16/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController, UIWebViewDelegate {

    //So we can test the next pages
    @IBOutlet weak var nextPageTest: UIButton!
    @IBOutlet weak var Webview: UIWebView?
    
    var data = NSMutableData()
    
    var activityIndicator:UIActivityIndicatorView? = nil
    
    // For PPRD use this
    var URLPath = "https://bannersso.cis-qas.brown.edu/SSB_PPRD"
    
    // For DPRD use this
//    var URLPath = "https://dshibproxycit.services.brown.edu/SSB_DPRD"
    
    var cookie : NSHTTPCookie = NSHTTPCookie()
    
    var cookieJar : NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    
    func loadAddressURL() {
        let requestURL = NSURL(string:URLPath)
        let request = NSURLRequest(URL:requestURL!)
        Webview?.delegate = self
        Webview?.loadRequest(request)
    }
    
    @IBAction func nextPage(sender: AnyObject) {
        self.performSegueWithIdentifier("loginToCal", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkInternet(false, completionHandler:
            {(internet:Bool) -> Void in
                
                if (internet)
                {
                    self.loadAddressURL()
                }
                else
                {
//                    var launchImage = UIImage(named: "Launch")
//                    var launchView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
//                    launchView.image = launchImage
//                    self.view.addSubview(launchView)
                    let alertController = UIAlertController(title: "No Internet:", message:
                        "There is no internet connection and so we cannot sync with banner. Please fix your connection again later.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Exit", style: UIAlertActionStyle.Cancel, handler: {alertAction in
                        alertController.dismissViewControllerAnimated(true, completion: nil)
                        exit(0)
                        
                    }))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                   
                }
        })
        
        Webview?.scrollView.scrollEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func webViewDidStartLoad(webView : UIWebView) {
    }
    
    func webViewDidFinishLoad(webView : UIWebView) {
        var loggedIn = webView.stringByEvaluatingJavaScriptFromString("window.location.href")
        if (loggedIn! == "https://selfservice-qas.brown.edu/ssPPRD/twbkwbis.P_GenMenu?name=bmenu.P_MainMnu") {
            webView.hidden = true;
            nextPageTest.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        }
    }
    
    func checkInternet(flag:Bool, completionHandler:(internet:Bool) -> Void)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let url = NSURL(string: "http://www.google.com/")
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        NSURLConnection.sendAsynchronousRequest(request, queue:NSOperationQueue.mainQueue(), completionHandler:
            {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                let rsp = response as! NSHTTPURLResponse?
                
                completionHandler(internet:rsp?.statusCode == 200)
        })
    }

}

