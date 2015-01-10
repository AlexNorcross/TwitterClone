//
//  UserTimelineViewController.swift
//  TwitterClone
//
//  Created by Alexandra Norcross on 1/8/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import UIKit

class UserTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  //NOTE: these properties are required to properly display View Controller
  var networkController: NetworkController!
  var selectedTweet: Tweet!
  
  //Table view header:
  @IBOutlet weak var imageUserBackground: UIImageView!
  @IBOutlet weak var imageUser: UIImageView!
  @IBOutlet weak var labelUsername: UILabel!
  @IBOutlet weak var labelLocation: UILabel!
  
  //Table: to display tweets
  @IBOutlet weak var tableTweets: UITableView!
  
  //Array of tweets: to display in table
  var tweets: [Tweet]?
  
  //Function: Set View Controller to display user's Tweets.
  override func viewDidLoad() {
    //Super:
    super.viewDidLoad()
    
    //Set table view header.
    //Background image:
    networkController.fetchUserBackgroundImage(selectedTweet.userID, urlImage: selectedTweet.userImageBackgroundURL, completionHandler: { (imageBackground) -> () in
      if imageBackground != nil {
        self.imageUserBackground.image = imageBackground
      } //end if
    }) //end closure
    //User image:
    networkController.fetchUserImage(selectedTweet, completionHandler: { (imageUser) -> () in
      if imageUser != nil {
        self.imageUser.image = imageUser
      } //end if
    }) //end closure
    //Labels:
    labelUsername.text = selectedTweet.username
    labelLocation.text = selectedTweet.userLocation
    
    //Register table view cell nib.
    self.tableTweets.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL_TWEET")
    //Adjust row height [automatically].
    tableTweets.estimatedRowHeight = 144
    tableTweets.rowHeight = UITableViewAutomaticDimension
    
    //Fetch and display user timeline.
    networkController.fetchUserTimeline(selectedTweet.userID) { (tweets, errorString) -> () in
      if errorString == nil {
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
    cellTweet.labelUsername.text = selectedTweet.username
    
    //If tweet is a retweet, show retweeter user's image; else show user's image.
    if let retweet = currentTweet.fetchRetweet(currentTweet) {
      networkController.fetchUserImage(retweet, completionHandler: { (imageUser) -> () in
        if imageUser != nil {
          cellTweet.imageUser.image = imageUser
        } //end if
      }) //end closure
    } else {
      networkController.fetchUserImage(selectedTweet, completionHandler: { (imageUser) -> () in
        if imageUser != nil {
          cellTweet.imageUser.image = imageUser
        } //end if
      }) //end closure
    }//end if
    
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
  } //end function
}
