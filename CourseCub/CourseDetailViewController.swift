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
    var locationLabel = UILabel()
    var bookListLabel = UILabel()
    var criticalReviewLabel = UILabel()
    var coursePreviewLabel = UILabel()
    var lineOne = UIView()
    var lineTwo = UIView()
    var lineThree = UIView()
    var lineFour = UIView()
    var lineFive = UIView()
    var lineSix = UIView()
    var lineSeven = UIView()
    var lineEight = UIView()
    
    var margin = CGFloat(0)
    var lineMargin = CGFloat(0)
    var lineOffset = CGFloat(0)
    var buttonViewHeight = CGFloat(0)
    var actualButtonViewHeight = CGFloat(0)
    var imageOffsetX = CGFloat(0)
    var imageOffsetY = CGFloat(0)
    var buttonImageOffsetY = CGFloat(0)
    var buttonImageOffsetX = CGFloat(0)
    var bounce = CGFloat(0)
    var textImageOffset = CGFloat(0)
    var imageDimension = CGFloat(0)
    
    var labelWidth = CGFloat(0)
    var lineWidth = CGFloat(0)

    @IBOutlet weak var addToCartImage: UIBarButtonItem!
    
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


    override func viewDidLoad() {
        super.viewDidLoad()


        
        var scrollView = UIScrollView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        self.view.addSubview(scrollView)
        
        var backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton;
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        
        
        var cartImage = UIImageView(frame: CGRectMake(0, 0, imageDimension, imageDimension))
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
        
        margin = CGFloat(20)
        lineMargin = CGFloat(10)
        lineOffset = CGFloat(10)
        buttonViewHeight = CGFloat(60)
        actualButtonViewHeight = buttonViewHeight + 2 * lineOffset
        imageOffsetX = CGFloat(5)
        imageOffsetY = CGFloat(0)
        buttonImageOffsetY = lineOffset
        buttonImageOffsetX = lineOffset + imageOffsetX
        bounce = CGFloat(75)
        textImageOffset = CGFloat(10)
        imageDimension = CGFloat(60)
        var arrowSize = CGFloat(25)
        
        labelWidth = self.view.frame.width - 2 * margin
        lineWidth = self.view.frame.width - 2 * lineMargin
        
        
        var titleLabel = UILabel(frame: CGRectMake(margin, margin, labelWidth, 0))
        titleLabel.text = course.title
        titleLabel.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1);
        titleLabel.font = UIFont(name: "Avenir-Roman", size: 20)!
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.width
        titleLabel.sizeToFit()
        titleLabel.textAlignment = NSTextAlignment.Center

        if titleLabel.frame.width < (labelWidth) {
            titleLabel.frame = CGRectOffset(titleLabel.frame, (labelWidth - titleLabel.frame.width) / 2 , 0)
        }
//        titleLabel.text = course.crn as String
//        titleLabel.numberOfLines = 0;
//        titleLabel.preferredMaxLayoutWidth = 539
        scrollView.addSubview(titleLabel)
        
        var meetingTimeLabel = UILabel(frame: CGRectMake(margin, getPosition(titleLabel), labelWidth, 0))
        var meetingParts = course.meeting_time.componentsSeparatedByString(" ")
        meetingTimeLabel.text = meetingParts[3] + " " + meetingParts[4]
        meetingTimeLabel.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 0.6);
        meetingTimeLabel.font = UIFont(name: "Avenir-Roman", size: 16)!
        
        meetingTimeLabel.numberOfLines = 0
        meetingTimeLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        meetingTimeLabel.preferredMaxLayoutWidth = meetingTimeLabel.frame.width
        meetingTimeLabel.sizeToFit()
        meetingTimeLabel.textAlignment = NSTextAlignment.Center
        
        if meetingTimeLabel.frame.width < (labelWidth) {
            meetingTimeLabel.frame = CGRectOffset(meetingTimeLabel.frame, (labelWidth - meetingTimeLabel.frame.width) / 2 , 0)
        }
        
        scrollView.addSubview(meetingTimeLabel)
        
        lineOne = UIView(frame: CGRectMake(0 , lineOffset + getPosition(meetingTimeLabel), self.view.frame.width, 1))
        lineOne.backgroundColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 0.6);
        
        scrollView.addSubview(lineOne)
        
        var seatsView =  UIView(frame: CGRectMake(lineMargin, lineOffset + getPosition(lineOne), lineWidth, buttonViewHeight))

        scrollView.addSubview(seatsView)
        var seatsImageView = UIImageView(frame: CGRectMake(imageOffsetX, imageOffsetY, imageDimension, imageDimension))
        var seatsImage = UIImage(named: "Seats")
            seatsImageView.image = seatsImage
        var seatsLabel = UILabel(frame: CGRectMake(seatsImageView.frame.width + textImageOffset + imageOffsetX, 0, seatsView.frame.width - seatsImageView.frame.width - textImageOffset, seatsView.frame.height))
        seatsLabel.text = String(course.numStudentsRegistered) + " / " + String(course.numStudentsAllowed);
        seatsLabel.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1);
        seatsLabel.font = UIFont(name: "Avenir-Roman", size: 20)!
        seatsView.addSubview(seatsImageView)
        seatsView.addSubview(seatsLabel)
        cartImage.frame = CGRectMake(seatsView.frame.width - imageDimension - imageOffsetX, imageOffsetY, imageDimension, imageDimension)
        seatsView.addSubview(cartImage)
        lineTwo = UIView(frame: CGRectMake(lineMargin, lineOffset + getPosition(seatsView), lineWidth, 1))
        lineTwo.backgroundColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 0.6);
        scrollView.addSubview(lineTwo)
        
        var locationView =  UIButton(frame: CGRectMake(0, getPosition(lineTwo), self.view.frame.width, actualButtonViewHeight))
        
        scrollView.addSubview(locationView)
        var locationImageView = UIImageView(frame: CGRectMake(buttonImageOffsetX, buttonImageOffsetY, imageDimension, imageDimension))
        var locationImage = UIImage(named: "Location")
        locationImageView.image = locationImage
        locationLabel = UILabel(frame: CGRectMake(locationImageView.frame.width + textImageOffset + buttonImageOffsetX, 0, locationView.frame.width - locationImageView.frame.width - textImageOffset - buttonImageOffsetX - arrowSize - lineOffset - lineOffset - imageOffsetX, locationView.frame.height))
        locationLabel.text = course.location as String
        locationLabel.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1);
        locationLabel.font = UIFont(name: "Avenir-Roman", size: 20)!
        var locationArrow = UIImageView(frame: CGRectMake(locationView.frame.width - arrowSize - lineOffset - imageOffsetX, (locationView.frame.height - arrowSize) / 2, arrowSize, arrowSize))
        locationLabel.numberOfLines = 0
        locationLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        locationLabel.preferredMaxLayoutWidth = locationLabel.frame.width
        var oldWidth = locationLabel.frame.width
        locationLabel.sizeToFit()
        
        if locationLabel.frame.height < locationView.frame.height {
            locationLabel.frame = CGRectMake(locationLabel.frame.origin.x, locationLabel.frame.origin.y, locationLabel.frame.width, locationView.frame.height)
        }
        else {
            locationView.frame = CGRectMake(0, getPosition(lineTwo), self.view.frame.width, locationLabel.frame.height)
            locationImageView.frame = CGRectMake(locationImageView.frame.origin.x, (locationView.frame.height - imageDimension) / 2, imageDimension, imageDimension)
            locationArrow.frame = CGRectMake(locationArrow.frame.origin.x, (locationView.frame.height - arrowSize) / 2, arrowSize, arrowSize)
        }
        
        
        
        locationArrow.image = UIImage(named: "Arrow")
        locationView.addSubview(locationArrow)
        locationView.addSubview(locationImageView)
        locationView.addSubview(locationLabel)
        locationView.addTarget(self, action: "getLocation:", forControlEvents: UIControlEvents.TouchUpInside)
        locationView.addTarget(self, action: "revertColorLocation:", forControlEvents: UIControlEvents.TouchUpOutside)
        locationView.addTarget(self, action: "highlightColorLocation:", forControlEvents: UIControlEvents.TouchDown)
 

        
        lineThree = UIView(frame: CGRectMake(lineMargin, getPosition(locationView), lineWidth, 1))
        lineThree.backgroundColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 0.6);
        scrollView.addSubview(lineThree)
        
        var instructorView =  UIView(frame: CGRectMake(lineMargin, lineOffset + getPosition(lineThree), lineWidth, buttonViewHeight))
        
        scrollView.addSubview(instructorView)
        var instructorImageView = UIImageView(frame: CGRectMake(imageOffsetX, imageOffsetY, imageDimension, imageDimension))
        var instructorImage = UIImage(named: "Instructor")
        instructorImageView.image = instructorImage
        var instructorLabel = UILabel(frame: CGRectMake(instructorImageView.frame.width + textImageOffset + imageOffsetX, 0, instructorView.frame.width - instructorImageView.frame.width - textImageOffset, instructorView.frame.height))
        instructorLabel.text = course.instructor as String
        instructorLabel.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1);
        instructorLabel.font = UIFont(name: "Avenir-Roman", size: 20)!
        instructorView.addSubview(instructorImageView)
        instructorView.addSubview(instructorLabel)
        
        lineFour = UIView(frame: CGRectMake(lineMargin, lineOffset + getPosition(instructorView), lineWidth, 1))
        lineFour.backgroundColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 0.6);
        scrollView.addSubview(lineFour)

        
        var descriptionLabel = UILabel(frame: CGRectMake(margin, lineOffset + getPosition(lineFour), labelWidth, 0))
        descriptionLabel.text = "Description:\n" + course.description + "\n\nCrn:\n" + course.crn
        descriptionLabel.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1)
        descriptionLabel.font = UIFont(name: "Avenir-Roman", size: 16)!
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        descriptionLabel.preferredMaxLayoutWidth = descriptionLabel.frame.width
        descriptionLabel.sizeToFit()
        
        if descriptionLabel.frame.width < (labelWidth) {
            descriptionLabel.frame = CGRectOffset(descriptionLabel.frame, (labelWidth - descriptionLabel.frame.width) / 2 , 0)
        }
        
        scrollView.addSubview(descriptionLabel)
        
        lineFive = UIView(frame: CGRectMake(lineMargin, lineOffset + getPosition(descriptionLabel), lineWidth, 1))
        lineFive.backgroundColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 0.6);
        scrollView.addSubview(lineFive)

        var bookListView =  UIButton(frame: CGRectMake(0, getPosition(lineFive), self.view.frame.width, actualButtonViewHeight))
        
        scrollView.addSubview(bookListView)
        var bookListImageView = UIImageView(frame: CGRectMake(buttonImageOffsetX, buttonImageOffsetY, imageDimension, imageDimension))
        var bookListImage = UIImage(named: "Books")
        bookListImageView.image = bookListImage
        bookListLabel = UILabel(frame: CGRectMake(bookListImageView.frame.width + textImageOffset + buttonImageOffsetX, 0, bookListView.frame.width - bookListImageView.frame.width - textImageOffset - buttonImageOffsetX - arrowSize - imageOffsetX, bookListView.frame.height))
        bookListLabel.text = "Book List"
        bookListLabel.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1)
        bookListLabel.font = UIFont(name: "Avenir-Roman", size: 20)!
        var bookListArrow = UIImageView(frame: CGRectMake(bookListView.frame.width - arrowSize - lineOffset - imageOffsetX, (bookListView.frame.height - arrowSize) / 2, arrowSize, arrowSize))
        bookListArrow.image = UIImage(named: "Arrow")
        bookListView.addSubview(bookListArrow)
        bookListView.addSubview(bookListImageView)
        bookListView.addSubview(bookListLabel)
        bookListView.addTarget(self, action: "getBookList:", forControlEvents: UIControlEvents.TouchUpInside)
        bookListView.addTarget(self, action: "revertColorBookList:", forControlEvents: UIControlEvents.TouchUpOutside)
        bookListView.addTarget(self, action: "highlightColorBookList:", forControlEvents: UIControlEvents.TouchDown)
        
        lineSix = UIView(frame: CGRectMake(lineMargin, getPosition(bookListView), lineWidth, 1))
        lineSix.backgroundColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 0.6);
        scrollView.addSubview(lineSix)
        
        var coursePreviewView =  UIButton(frame: CGRectMake(0, getPosition(lineSix), self.view.frame.width, actualButtonViewHeight))
        
        scrollView.addSubview(coursePreviewView)
        var coursePreviewImageView = UIImageView(frame: CGRectMake(buttonImageOffsetX, buttonImageOffsetY, imageDimension, imageDimension))
        var coursePreviewImage = UIImage(named: "Link")
        coursePreviewImageView.image = coursePreviewImage
        coursePreviewLabel = UILabel(frame: CGRectMake(coursePreviewImageView.frame.width + textImageOffset + buttonImageOffsetX, 0, coursePreviewView.frame.width - coursePreviewImageView.frame.width - textImageOffset - buttonImageOffsetX - arrowSize - imageOffsetX, coursePreviewView.frame.height))
        coursePreviewLabel.text = "Course Preview"
        coursePreviewLabel.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1)
        coursePreviewLabel.font = UIFont(name: "Avenir-Roman", size: 20)!
        var coursePreviewArrow = UIImageView(frame: CGRectMake(coursePreviewView.frame.width - arrowSize - lineOffset - imageOffsetX, (coursePreviewView.frame.height - arrowSize) / 2, arrowSize, arrowSize))
        coursePreviewArrow.image = UIImage(named: "Arrow")
        coursePreviewView.addSubview(coursePreviewArrow)
        coursePreviewView.addSubview(coursePreviewImageView)
        coursePreviewView.addSubview(coursePreviewLabel)
        coursePreviewView.addTarget(self, action: "getCoursePreview:", forControlEvents: UIControlEvents.TouchUpInside)
        coursePreviewView.addTarget(self, action: "revertColorCoursePreview:", forControlEvents: UIControlEvents.TouchUpOutside)
        coursePreviewView.addTarget(self, action: "highlightColorCoursePreview:", forControlEvents: UIControlEvents.TouchDown)
        
        lineSeven = UIView(frame: CGRectMake(lineMargin, getPosition(coursePreviewView), lineWidth, 1))
        lineSeven.backgroundColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 0.6);
        scrollView.addSubview(lineSeven)
        
        var criticalReviewView =  UIButton(frame: CGRectMake(0, getPosition(lineSeven), self.view.frame.width, actualButtonViewHeight))
        
        scrollView.addSubview(criticalReviewView)
        var criticalReviewImageView = UIImageView(frame: CGRectMake(buttonImageOffsetX, buttonImageOffsetY, imageDimension, imageDimension))
        var criticalReviewImage = UIImage(named: "Link")
        criticalReviewImageView.image = criticalReviewImage
        criticalReviewLabel = UILabel(frame: CGRectMake(criticalReviewImageView.frame.width + textImageOffset + buttonImageOffsetX, 0, criticalReviewView.frame.width - criticalReviewImageView.frame.width - textImageOffset - buttonImageOffsetX - arrowSize - imageOffsetX, criticalReviewView.frame.height))
        criticalReviewLabel.text = "Critical Review"
        criticalReviewLabel.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1)
        criticalReviewLabel.font = UIFont(name: "Avenir-Roman", size: 20)!
        var criticalReviewArrow = UIImageView(frame: CGRectMake(criticalReviewView.frame.width - arrowSize - lineOffset - imageOffsetX, (criticalReviewView.frame.height - arrowSize) / 2, arrowSize, arrowSize))
        criticalReviewArrow.image = UIImage(named: "Arrow")
        criticalReviewView.addSubview(criticalReviewArrow)
        criticalReviewView.addSubview(criticalReviewImageView)
        criticalReviewView.addSubview(criticalReviewLabel)
        criticalReviewView.addTarget(self, action: "getCriticalReview:", forControlEvents: UIControlEvents.TouchUpInside)
        criticalReviewView.addTarget(self, action: "revertColorCriticalReview:", forControlEvents: UIControlEvents.TouchUpOutside)
        criticalReviewView.addTarget(self, action: "highlightColorCriticalReview:", forControlEvents: UIControlEvents.TouchDown)
        
        lineEight = UIView(frame: CGRectMake(lineMargin, getPosition(criticalReviewView), lineWidth, 1))
        lineEight.backgroundColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 0.6);

        scrollView.addSubview(lineEight)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: bounce + getPosition(lineEight))
        
        self.view.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
        scrollView.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
    }
    
    func highlightColorLocation(sender:UIButton!){
        sender.backgroundColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 0.6)
        self.locationLabel.textColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
        lineTwo.frame =  CGRectMake(0, lineTwo.frame.origin.y , self.view.frame.width, 1)
        lineThree.frame =  CGRectMake(0, lineThree.frame.origin.y , self.view.frame.width, 1)
    }
    
    func revertColorLocation(sender:UIButton!){
        sender.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
        self.locationLabel.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1)
        lineTwo.frame =  CGRectMake(lineMargin, lineTwo.frame.origin.y , lineWidth, 1)
        lineThree.frame =  CGRectMake(lineMargin, lineThree.frame.origin.y , lineWidth, 1)
    }
    
    func highlightColorBookList(sender:UIButton!){
        sender.backgroundColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 0.6)
        self.bookListLabel.textColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
        lineFive.frame =  CGRectMake(0, lineFive.frame.origin.y , self.view.frame.width, 1)
        lineSix.frame =  CGRectMake(0, lineSix.frame.origin.y , self.view.frame.width, 1)
    }
    
    func revertColorBookList(sender:UIButton!){
        sender.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
        self.bookListLabel.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1)
        lineFive.frame =  CGRectMake(lineMargin, lineFive.frame.origin.y , lineWidth, 1)
        lineSix.frame =  CGRectMake(lineMargin, lineSix.frame.origin.y , lineWidth, 1)
    }
    
    func highlightColorCoursePreview(sender:UIButton!){
        sender.backgroundColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 0.6)
        self.coursePreviewLabel.textColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
        lineSix.frame =  CGRectMake(0, lineSix.frame.origin.y , self.view.frame.width, 1)
        lineSeven.frame =  CGRectMake(0, lineSeven.frame.origin.y , self.view.frame.width, 1)
    }
    
    func revertColorCoursePreview(sender:UIButton!){
        sender.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
        self.coursePreviewLabel.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1)
        lineSix.frame =  CGRectMake(lineMargin, lineSix.frame.origin.y , lineWidth, 1)
        lineSeven.frame =  CGRectMake(lineMargin, lineSeven.frame.origin.y , lineWidth, 1)
    }
    
    func highlightColorCriticalReview(sender:UIButton!){
        sender.backgroundColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 0.6)
        self.criticalReviewLabel.textColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
        lineSeven.frame =  CGRectMake(0, lineSeven.frame.origin.y , self.view.frame.width, 1)
        lineEight.frame =  CGRectMake(0, lineEight.frame.origin.y ,  self.view.frame.width, 1)

    }
    
    func revertColorCriticalReview(sender:UIButton!){
        sender.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
        self.criticalReviewLabel.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1)
        lineSeven.frame =  CGRectMake(lineMargin, lineSeven.frame.origin.y , lineWidth, 1)
        lineEight.frame =  CGRectMake(lineMargin, lineEight.frame.origin.y , lineWidth, 1)
    }
    
    func getLocation(sender:UIButton!) {
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let locationController = sb.instantiateViewControllerWithIdentifier("locationViewController") as! LocationViewController
        locationController.location = course.location as String
        self.navigationController?.pushViewController(locationController, animated: true);
        sender.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
        self.locationLabel.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1)
        lineTwo.frame =  CGRectMake(lineMargin, lineTwo.frame.origin.y , lineWidth, 1)
        lineThree.frame =  CGRectMake(lineMargin, lineThree.frame.origin.y , lineWidth, 1)
    }
    
    func getBookList(sender:UIButton!) {
        println("There are no booklists")
        sender.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
        self.bookListLabel.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1)
        lineFive.frame =  CGRectMake(lineMargin, lineFive.frame.origin.y , lineWidth, 1)
        lineSix.frame =  CGRectMake(lineMargin, lineSix.frame.origin.y , lineWidth, 1)
    }
    
    func getCoursePreview(sender:UIButton!) {
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let linkController = sb.instantiateViewControllerWithIdentifier("linkViewController") as! LinkViewController
        linkController.URLPath = course.course_preview
        self.navigationController?.pushViewController(linkController, animated: true);
        sender.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
        self.coursePreviewLabel.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1)
        lineSix.frame =  CGRectMake(lineMargin, lineSix.frame.origin.y , lineWidth, 1)
        lineSeven.frame =  CGRectMake(lineMargin, lineSeven.frame.origin.y , lineWidth, 1)
    }
    
    func getCriticalReview(sender:UIButton!) {
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let linkController = sb.instantiateViewControllerWithIdentifier("linkViewController") as! LinkViewController
        linkController.URLPath = course.critical_review
        self.navigationController?.pushViewController(linkController, animated: true);
        sender.backgroundColor = UIColor(red: 0.976, green: 0.972, blue: 0.956, alpha: 1)
        self.criticalReviewLabel.textColor = UIColor(red: 0.2235, green: 0.1176, blue: 0.1058, alpha: 1)
        lineSeven.frame =  CGRectMake(lineMargin, lineSeven.frame.origin.y , lineWidth, 1)
        lineEight.frame =  CGRectMake(lineMargin, lineEight.frame.origin.y , lineWidth, 1)

    }
    
    func getPosition(view: UIView) -> CGFloat {
        return view.frame.origin.y + view.frame.height
    }
}
