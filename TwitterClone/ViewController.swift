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
  var tweets: [Tweet]?
  
  //Function: Set View Controller to display Tweets.
  override func viewDidLoad() {
    //Super:
    super.viewDidLoad()
    
    //Register table view cell nib.
    tableTweets.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL_TWEET")
    //Adjust row height [automatically].
    tableTweets.estimatedRowHeight = 144
    tableTweets.rowHeight = UITableViewAutomaticDimension
    
    //Fetch and display Twitter timeline.
    networkController.fetchHomeTimeline { (tweets, errorString) -> () in
      if errorString == nil {
        self.tweets = tweets!
        self.tableTweets.reloadData() //reload table to display timeline
      } else {
        println(errorString!)
      } //end if
    } //end closure
        
    //Table view: data source & delegate.
    tableTweets.dataSource = self
    tableTweets.delegate = self
  } //end func
  
  //Function: Set table row count.
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tweets != nil {
      return tweets!.count
    } else {
      return 0
    } //end if
  } //end func
  
  //Function: Set table cell contents.
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //Cell:
    var cellTweet = tableView.dequeueReusableCellWithIdentifier("CELL_TWEET", forIndexPath: indexPath) as TweetCell
    //Current tweet array/table row:
    var currentTweet = tweets![indexPath.row]
    
    //Set cell contents.
    cellTweet.labelTweet.text = currentTweet.text
    cellTweet.labelUsername.text = currentTweet.username
    networkController.fetchUserImage(currentTweet, completionHandler: { (imageUser) -> () in
      if imageUser != nil {
        cellTweet.imageUser.image = imageUser
      } //end if
    }) //end closure
    
    //Return cell.
    return cellTweet
  } //end func
  
  //Function: Display Tweet infomation View Controller when cell is selected.
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //Selected Tweet:
    let selectedTweet = tweets![indexPath.row]
    
    //Prepare Tweet information View Controller.
    let vcTweetInfo = self.storyboard?.instantiateViewControllerWithIdentifier("VC_TWEET_INFO") as TweetInfoViewController
    vcTweetInfo.networkController = networkController
    vcTweetInfo.selectedTweet = selectedTweet
    
    //Display View Controller.
    self.navigationController?.pushViewController(vcTweetInfo, animated: true)
  } //end func
}

