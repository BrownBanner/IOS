//
//  DepartmentViewController.swift
//  CourseCub
//
//  Created by Cody R Fitzgerald on 2/16/15.
//  Copyright (c) 2015 Cody R Fitzgerald. All rights reserved.
//

import UIKit

var dep_list = appDelegate.department_list

class DepartmentViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, NSURLSessionDelegate {
    
    var alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
    var alphabet_dict = Dictionary<String, Int>()
    var alphabet_count = [Int](count: 26, repeatedValue: 0);
    var favorites = [Department]()

    var tableData = []
    
    @IBOutlet var tView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "department")
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        for letter in alphabet {
            alphabet_dict[letter] = 0
        }
        
        
        countSections()
//        getClasses("a")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return alphabet.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var letter = ""
        for var i = 0 ; i < alphabet.count; i++ {
            if i == section {
                letter = alphabet[i]
            }
        }
        return alphabet_dict[letter]!
    }

    
    //THIS WILL BE THE API CALL
    func getClasses(searchTerm: String) {
        
        //Something like this will be useful eventually
        //let searchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        //This will also be useful eventually
        //if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            let urlPath = "https://ords-dev.brown.edu/dprd/banner/mobile/courses?term=201420"
            let url = NSURL(string: urlPath)
            //let session = NSURLSession.sharedSession()
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
            let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
                println("Task completed")
                if(error != nil) {
                    // If there is an error in the web request, print it to the console
                    println(error.localizedDescription)
                }
                var err: NSError?
                
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                print(jsonResult)
                print("hi")
                if(err != nil) {
                    // If there is an error parsing JSON, print it to the console
                    println("JSON Error \(err!.localizedDescription)")
                }
                let results: NSArray = jsonResult["results"] as NSArray
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableData = results
                    self.tableView!.reloadData()
                })
            })
            print(tableData)
            
            task.resume()
        //}
    }
    
    /*func urlSessionCompHand {
        println("Task completed")
        if(error != nil) {
            // If there is an error in the web request, print it to the console
            println(error.localizedDescription)
        }
        var err: NSError?
        
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
        print(jsonResult)
        print("hi")
        if(err != nil) {
            // If there is an error parsing JSON, print it to the console
            println("JSON Error \(err!.localizedDescription)")
        }
        let results: NSArray = jsonResult["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = results
            self.tableView!.reloadData()
        })
    }*/
    
    /* This function is a workaround for CIS's bad SSL*/
    func URLSession(session: NSURLSession!, didReceiveChallenge challenge: NSURLAuthenticationChallenge!, completionHandler:  ((NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void)!) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust && challenge.protectionSpace.host == "ords-dev.brown.edu" {
            let credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust)
            challenge.sender.useCredential(credential, forAuthenticationChallenge: challenge)
        } else {
            challenge.sender.performDefaultHandlingForAuthenticationChallenge!(challenge)
        }
        
        
    }
    
   /* Original Copy
    func URLSession(session: NSURLSession!, didReceiveChallenge challenge: NSURLAuthenticationChallenge!, completionHandler: ((NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void)!) {
        
        if challenge.protectionSpace.authenticationMethod.compare(NSURLAuthenticationMethodServerTrust) == 0 {
            if challenge.protectionSpace.host.compare("HOST_NAME") == 0 {
                completionHandler(.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust))
            }
            
        } else if challenge.protectionSpace.authenticationMethod.compare(NSURLAuthenticationMethodHTTPBasic) == 0 {
            if challenge.previousFailureCount > 0 {
                println("Alert Please check the credential")
                completionHandler(NSURLSessionAuthChallengeDisposition.CancelAuthenticationChallenge, nil)
            } else {
                var credential = NSURLCredential(user:"username", password:"password", persistence: .ForSession)
                completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential,credential)
            }
        }
        
    }
    
    func URLSession(session: NSURLSession!, task: NSURLSessionTask!, didReceiveChallenge challenge: NSURLAuthenticationChallenge!, completionHandler: ((NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void)!){
        
        println("task-didReceiveChallenge")
        
        if challenge.previousFailureCount > 0 {
            println("Alert Please check the credential")
            completionHandler(NSURLSessionAuthChallengeDisposition.CancelAuthenticationChallenge, nil)
        } else {
            var credential = NSURLCredential(user:"username", password:"password", persistence: .ForSession)
            completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential,credential)
        }
        
        
    }*/
    
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return self.alphabet
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return index
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        var row_increment = 0
        if (indexPath.section != 0){
            row_increment = alphabet_count[indexPath.section - 1]
        }
        
        cell.textLabel.text = dep_list[row_increment + indexPath.row].abbrev;
        
        var title_label = UILabel(frame: CGRectMake(105, 0, 210, 40))
        title_label.text = dep_list[row_increment + indexPath.row].name;
        cell.contentView.addSubview(title_label)
        

        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return alphabet[section]
    }



    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //Check the first letters of each item in the departmentAbbrevArray, change the letter to a number corresponding to the section numbers, and then use those numbers to count the number of items in each alphabetical section. UGH.
    func countSections () {
        
        for department in dep_list {
            var firstLetter = department.abbrev.substringToIndex(advance(department.abbrev.startIndex, 1))
            if alphabet_dict[firstLetter] == nil {
                alphabet_dict[firstLetter] = 0
            } else {
                alphabet_dict[firstLetter] = 1 + alphabet_dict[firstLetter]!
            }
        }
        
        for var i = 0 ; i < alphabet.count; i++ {
            var previous = 0
            if (i != 0) {
                previous = alphabet_count[i - 1]
            }
            alphabet_count[i] = alphabet_dict[alphabet[i]]! + previous
            
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 0
        } else {
            if (alphabet_count[section] == 0) {
                return 0
            }
            else if (section > 1) {
                if (alphabet_count[section] == alphabet_count[section - 1]) {
                    return 0
                }
            }
           return 20
        }
        
    }
    
    

}
