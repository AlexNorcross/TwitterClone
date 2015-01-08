//
//  ViewController.swift
//  TwitterClone
//
//  Created by Alexandra Norcross on 1/6/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  //Table: to display tweets
  @IBOutlet weak var tableTweets: UITableView!
  
  //Network Controller: to access Twitter account
  let networkController = NetworkController()
  
  //Array of tweets: to display in table
  var tweets = [Tweet]()
  
  //Function: Set View Controller to display Tweets.
  override func viewDidLoad() {
    //Super:
    super.viewDidLoad()
    
    //Fetch and display Twitter account timeline.
    networkController.fetchHomeTimeline { (tweets, errorString) -> () in
      if errorString == nil { //no errors: reload table to display timeline
        self.tweets = tweets!
        self.tableTweets.reloadData()
      } else { //error: print error
        println(errorString!)
      } //end if
    } //end closure
        
    //Table view: data source & delegate.
    tableTweets.dataSource = self
    tableTweets.delegate = self
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
    //Set cell contents.
    cellTweet.labelTweet.text = currentTweet.text
    cellTweet.labelUsername.text = currentTweet.username
    //Return cell.
    return cellTweet
  } //end func
  
  //Function: Display Tweet infomation when user selects a cell.
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //Selected Tweet:
    let selectedTweet = tweets[indexPath.row]
    
    //Fetch information of selected Tweet and handle callback.
    networkController.fetchTweetInfo(selectedTweet.id, keyTweetInfo: "favorite_count", completionHandler: { (countFavorite, errorString) -> () in
      if errorString == nil { //no errors: display Tweet information View Controller
        //Set selected Tweet's information.
        selectedTweet.countFavorite = countFavorite!
        
        //Get Tweet information View Controller; and set selected Tweet.
        let vcTweetInfo = self.storyboard?.instantiateViewControllerWithIdentifier("VC_TWEET_INFO") as TweetInfoViewController
        vcTweetInfo.selectedTweet = selectedTweet
        
        //Display Tweet information View Controller.
        self.navigationController?.pushViewController(vcTweetInfo, animated: true)
      } else { //error: print error
        println(errorString!)
      } //end if
    }) //end closure
  } //end func
}

