//
//  CourseDetailViewController.swift
//  CourseCub
//
//  Created by Cody R Fitzgerald on 2/16/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import UIKit

class CourseDetailViewController: UIViewController, UIScrollViewDelegate  {

    var course = Course(jsonCourse: JSON(""));
    var inCart = false;
    
    @IBOutlet var scrollView: UIView!
    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet var trueScrollView: UIScrollView!
    @IBOutlet var seatsImage: UIImageView!
    @IBOutlet var instructorImage: UIImageView!
    @IBOutlet var locationImage: UIImageView!
    @IBOutlet var meetingLabel: UILabel!
    @IBOutlet var seatsLabel: UILabel!
    @IBOutlet var instructorLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var moreInfoImage: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var lineOne: UIImageView!
    @IBOutlet var lineTwo: UIImageView!
    @IBOutlet var lineThree: UIImageView!
    @IBOutlet var lineFour: UIImageView!
    @IBOutlet var lineFive: UIImageView!
    @IBOutlet var lineSix: UIImageView!
    @IBOutlet var moreInfoText: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var addToCartImage: UIBarButtonItem!
    @IBOutlet var bookListButton: UIButton!
    @IBAction func bookListClick(sender: AnyObject) {
    }
    @IBOutlet var critReviewButton: UIButton!
    @IBAction func critReviewClick(sender: AnyObject) {
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let linkController = sb.instantiateViewControllerWithIdentifier("linkViewController") as! LinkViewController
        linkController.URLPath = course.critical_review
        self.navigationController?.pushViewController(linkController, animated: true);
    }
    @IBOutlet var coursePreviewButton: UIButton!
    @IBAction func coursePreviewClick(sender: AnyObject) {
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let linkController = sb.instantiateViewControllerWithIdentifier("linkViewController") as! LinkViewController
        linkController.URLPath = course.course_preview
        self.navigationController?.pushViewController(linkController, animated: true);
    }
    
    @IBAction func addToCart(sender: AnyObject) {
        var defaults = NSUserDefaults.standardUserDefaults()
        var termCode = defaults.objectForKey(appDelegate.COURSE_TERM_CODE) as! String
        var urlPath = ""
        if (inCart) {
            urlPath = "https://ords-qa.services.brown.edu:8443/pprd/banner/mobile/cart?term=" + termCode + "&in_id=" + appDelegate.getSessionCookie() + "&crn=" + course.crn + "&in_type=D"
        }
        else {
            urlPath = "https://ords-qa.services.brown.edu:8443/pprd/banner/mobile/cart?term=" + termCode + "&in_id=" + appDelegate.getSessionCookie() + "&crn=" + course.crn + "&in_type=I"
        }
        let url = NSURL(string: urlPath)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
                return;
            } else {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let calVC = sb.instantiateViewControllerWithIdentifier("cal") as! CalendarViewController
                let calNAV = sb.instantiateViewControllerWithIdentifier("calNav") as! UINavigationController
                calNAV.setViewControllers([calVC], animated: false)
                self.revealViewController().rearViewRevealOverdraw = 0;
                var rvc = self.revealViewController()
                rvc.setFrontViewController(calNAV, animated: true)
                rvc.pushFrontViewController(calNAV, animated: true)
                return;
            }
            
        })
        
        task.resume()
    }
    @IBOutlet var locationButton: UIButton!
    @IBAction func locationClicked(sender: AnyObject) {
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let locationController = sb.instantiateViewControllerWithIdentifier("locationViewController") as! LocationViewController
        locationController.location = locationLabel.text!
        self.navigationController?.pushViewController(locationController, animated: true);

    }
    @IBOutlet var moreInfoButton: UIButton!
    @IBAction func moreInfoClicked(sender: AnyObject) {
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        inCart = appDelegate.currentCart.cartContains(course)
        if (inCart) {
            addToCartImage.image = UIImage(named: "RemoveFromCart")
            cartImage.image = UIImage(named: "InCart")
            if appDelegate.currentCart.isRegistered(course) {
                addToCartImage.enabled = false
            }
            else {
                addToCartImage.enabled = true
            }
        }
        else {
            addToCartImage.image = UIImage(named: "AddtoCartWhite")
            cartImage.image = nil
            addToCartImage.enabled = true

        }
        if appDelegate.currentCart.getCourses().count == 20 {
            addToCartImage.enabled = false
        }
        

        var leftConstraint = NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)
        var rightConstraint = NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0)
        self.view.addConstraint(leftConstraint)
        self.view.addConstraint(rightConstraint)
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.9411, green: 0.3254, blue: 0.3254, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.9411, green: 0.3254, blue: 0.3254, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.translucent = false;
        
        var backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton;
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 20)!]
        
        //Populates all UILabels with data
        var meetingParts = course.meeting_time.componentsSeparatedByString(" ")
        


        meetingLabel.text = meetingParts[3] + " " + meetingParts[4]
    
        instructorLabel.text = course.instructor as String
        seatsLabel.text = String(course.numStudentsRegistered) + " / " + String(course.numStudentsAllowed);
        if (inCart) {
            
        }

        locationLabel.text = course.location as String
        
        /*var coursePreviewLink = UIButton()
        
        var coursePreview = UIButton(frame: CGRectMake(10, 180, self.view.frame.size.width - 20, 40))
        coursePreview.setTitle("Course Preview", forState: UIControlState.Normal)
        coursePreview.addTarget(self, action: "viewCoursePreview:", forControlEvents: UIControlEvents.TouchUpInside)
        coursePreview.backgroundColor = UIColor.blueColor()
        self.view.addSubview(coursePreview)
        
        var criticalReview = UIButton(frame: CGRectMake(10, 220, self.view.frame.size.width - 20, 40))
        criticalReview.setTitle("Critical Review", forState: UIControlState.Normal)
        criticalReview.addTarget(self, action: "viewCriticalReview:", forControlEvents: UIControlEvents.TouchUpInside)
        criticalReview.backgroundColor = UIColor.redColor()
        self.view.addSubview(criticalReview)
        
        var bookList = UIButton(frame: CGRectMake(10, 260, self.view.frame.size.width - 20, 40))
        bookList.setTitle("Book List", forState: UIControlState.Normal)
        bookList.addTarget(self, action: "viewBookList:", forControlEvents: UIControlEvents.TouchUpInside)
        bookList.backgroundColor = UIColor.greenColor()
        self.view.addSubview(bookList)*/
        

        
        //self.view.addSubview(descriptionLabel)
        self.view.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
        self.scrollView.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
        
        titleLabel.text = course.title as String
        titleLabel.numberOfLines = 0;
        titleLabel.preferredMaxLayoutWidth = 539
        
        //titleLabel.sizeToFit()
        
        
        descriptionLabel.text = course.description as String + "\n" //+ course.prereqs + course.examinfo
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.preferredMaxLayoutWidth = 536
        //descriptionLabel.sizeToFit()
        //self.scrollView.setNeedsUpdateConstraints()
        
        /*let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        self.trueScrollView.contentSize.width = screenWidth;
        var frm = self.scrollView.frame
        frm.size.width = screenWidth;
        self.scrollView.frame = frm;*/
        
        titleLabel.sizeToFit()
        print(titleLabel.frame.height)
        println()
        descriptionLabel.sizeToFit()
        
        self.view.addSubview(trueScrollView)
        self.trueScrollView.addSubview(self.scrollView)
        self.scrollView.addSubview(seatsImage)
        self.scrollView.addSubview(instructorImage)
        self.scrollView.addSubview(locationImage)
        self.scrollView.addSubview(meetingLabel)
        self.scrollView.addSubview(titleLabel)
        self.scrollView.addSubview(seatsLabel)
        self.scrollView.addSubview(instructorLabel)
        self.scrollView.addSubview(locationLabel)
        self.scrollView.addSubview(moreInfoImage)
        self.scrollView.addSubview(lineOne)
        self.scrollView.addSubview(lineTwo)
        self.scrollView.addSubview(lineThree)
        self.scrollView.addSubview(lineFour)
        self.scrollView.addSubview(lineFive)
        self.scrollView.addSubview(lineSix)
        self.scrollView.addSubview(moreInfoText)
        self.scrollView.addSubview(descriptionLabel)
        self.scrollView.addSubview(coursePreviewButton)
        self.scrollView.addSubview(critReviewButton)
        
        //self.view.bringSubviewToFront(trueScrollView)
        
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("someSelector"), userInfo: nil, repeats: false)
        
        

        
    }
    
    func someSelector() {
        //self.titleLabel.sizeToFit()
        //self.descriptionLabel.sizeToFit()
        //self.scrollView.setNeedsLayout()
        trueScrollView.contentSize = CGSizeMake(self.view.frame.width, coursePreviewButton.frame.maxY);
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("scroll")
    }
    
   override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews();
        //titleLabel.preferredMaxLayoutWidth = self.titleLabel.bounds.size.width;
        //descriptionLabel.preferredMaxLayoutWidth = self.descriptionLabel.bounds.size.width;
        
        
        /*titleLabel.text = course.title as String
        titleLabel.numberOfLines = 0;
        titleLabel.sizeToFit()
        titleLabel.setNeedsDisplay()
        titleLabel.setNeedsUpdateConstraints()
        
        descriptionLabel.text = course.description as String
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.sizeToFit()
        descriptionLabel.setNeedsDisplay()
        descriptionLabel.setNeedsUpdateConstraints()
        
        self.scrollView.setNeedsDisplay()
        self.scrollView.setNeedsUpdateConstraints()
        self.trueScrollView.setNeedsDisplay()*/
    }
    
    func viewCoursePreview(sender:UIButton!) {
        
    }
    
    func viewCriticalReview(sender:UIButton!) {
        
    }
    
    func viewBookList(sender:UIButton!) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
