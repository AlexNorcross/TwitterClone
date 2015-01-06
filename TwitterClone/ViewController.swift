//
//  ViewController.swift
//  TwitterClone
//
//  Created by Alexandra Norcross on 1/6/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import UIKit
import Accounts
import Social

class ViewController: UIViewController, UITableViewDataSource {
  //Table: to display tweets
  @IBOutlet weak var tableTweets: UITableView!
  
  //Array of tweets: to display in table
  var tweets = [Tweet]()
  
  //Function: Set view controller.
  override func viewDidLoad() {
    //Super:
    super.viewDidLoad()
    
    //Access Twitter account and retrieve tweets.
    //Store & Type:
    let accountStoreTwitter = ACAccountStore()
    let accountType = accountStoreTwitter.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    //Access Twitter account and handle callback.
    accountStoreTwitter.requestAccessToAccountsWithType(accountType, options: nil) { (accessGranted, errorHandler) -> Void in
      //Handle callback re: access to accounts.
      if accessGranted { //access granted: access first Twitter account and load tweets
        let accountsTwitter = accountStoreTwitter.accountsWithAccountType(accountType) //Twitter accounts
        if !accountsTwitter.isEmpty { //has accounts
          //First Twitter account:
          let accountTwitter = accountsTwitter.first as ACAccount
          //Set up request for Twitter timeline: url, request, and account
          let urlTwitterTimeline = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
          let requestTwitter = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: urlTwitterTimeline, parameters: nil)
          requestTwitter.account = accountTwitter
          //Perform request.
          requestTwitter.performRequestWithHandler({ (jsonData, urlResponse, errorHandler) -> Void in
            //If request was successful, parse JSON file; else, handle error.
            switch urlResponse.statusCode {
            case 200...299: //success: parse JSON file
              //JSON file contains an array of tweets.
              //  each array unit contains a dictionary containing:
              //    * "text" key (string)
              //    * "user" key > value is dictionary containing:
              //        "name" key (string)
              var errorPointer: NSError?
              if let dataArray = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &errorPointer) as? [AnyObject] { //data in array
                for dataUnit in dataArray {
                  if let dataDictionary = dataUnit as? [String : AnyObject] { //data in dictionary
                    let newTweet = Tweet(jsonTweet: dataDictionary)
                    self.tweets.append(newTweet)
                  } //end if
                } //end for
              } //end if
              //Return to main thread.
              NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                self.tableTweets.reloadData()
              } //end closure
            default: //error
              println("twitter account error")
            } //end switch
          }) //end closure
        } else { //no accounts
          println("no accounts")
        } //end if
      } else { //access not granted
        println("access not granted")
      } //end if
    } //end closure
    
    //Table view: data source.
    tableTweets.dataSource = self
  } //end func
  
  //Function: Set table row count.
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count
  } //end func
  
  //Function: Set table cell contents.
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //Cell:
    var cellTweet = tableView.dequeueReusableCellWithIdentifier("CELL_TWEET", forIndexPath: indexPath) as TweetCell
    //Current tweet array/table row:
    var currentTweet = tweets[indexPath.row]
    //Set cell contents:
    cellTweet.labelTweet.text = currentTweet.text
    cellTweet.labelUsername.text = currentTweet.username
    //Return cell.
    return cellTweet
  } //end func
}

