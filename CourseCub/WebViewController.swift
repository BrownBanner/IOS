//
//  WebViewController.swift
//  CourseCub
//
//  Created by Brown Loaner on 4/12/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import Foundation
import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    var URL: String = "";
    override func viewDidLoad() {
        let requestURL = NSURL(string: URL)
        let request = NSURLRequest(URL: requestURL!)
//        Webview?.delegate = self
//        Webview?.loadRequest(request)
    }
    
}
