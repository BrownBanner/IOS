//
//  SettingsViewController.swift
//  CourseCub
//
//  Created by Alexander Meade on 24/04/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var termPicker: UIPickerView!
    @IBOutlet weak var logoutButton: UIButton!
    
    var termArray = ["Spring 2014", "Fall 2014", "Spring 2015", "Fall 2015"]
    var termCode = ["201420", "201410", "201520", "201510"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var tempTerm: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(appDelegate.COURSE_TERM_KEY)
        var tempIndex: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(appDelegate.COURSE_TERM_INDEX)
        var tempCode: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(appDelegate.COURSE_TERM_CODE)
    
        
        self.termPicker.dataSource = self
        self.termPicker.delegate = self
        self.termPicker.selectRow(tempIndex as! Int, inComponent: 0, animated: true)

        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealOverdraw = 0;
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.logoutButton.addTarget(self, action: Selector("logout:"), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logout(sender: UIButton!) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = sb.instantiateViewControllerWithIdentifier("loginView") as! ViewController
        
        var cookie : NSHTTPCookie = NSHTTPCookie()
        var cookieJar : NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        var cookies = cookieJar.cookies
        
        for cookie in cookies as! [NSHTTPCookie] {
            cookieJar.deleteCookie(cookie)
        }
        
        self.presentViewController(loginVC, animated: true, completion: nil)
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return termArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return termArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(termArray[row], forKey: appDelegate.COURSE_TERM_KEY)
        defaults.setObject(row, forKey: appDelegate.COURSE_TERM_INDEX)
        defaults.setObject(termCode[row], forKey: appDelegate.COURSE_TERM_CODE)
        defaults.synchronize()
    }
    
}
