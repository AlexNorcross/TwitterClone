//
//  TweetInfoViewController.swift
//  TwitterClone
//
//  Created by Alexandra Norcross on 1/7/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import UIKit

class TweetInfoViewController: UIViewController {
  //NOTE: these properties are required to properly display View Controller
  var networkController: NetworkController!
  var selectedTweet: Tweet!
  
  //Labels:
  @IBOutlet weak var labelUsername: UILabel!
  @IBOutlet weak var labelTweet: UILabel!
  @IBOutlet weak var labelCountFavorite: UILabel!
  @IBOutlet weak var labelCountRetweets: UILabel!
  
  //Button: to display user image
  @IBOutlet weak var buttonImageUser: UIButton!
  
  //Function: Set View Controller to display Tweet information.
  override func viewDidLoad() {
    //Super:
    super.viewDidLoad()
    
    //Fetch and display Tweet information.
    networkController.fetchTweetInfo(selectedTweet.id, completionHandler: { (tweetInfo, errorString) -> () in
      if errorString == nil {
        //Update selected Tweet's information.
        self.selectedTweet.updateWithInfo(tweetInfo!)
        //Set view.
        //Labels:
        self.labelUsername.text = self.selectedTweet.username
        self.labelTweet.text = self.selectedTweet.text
        self.labelCountFavorite.text = String(self.selectedTweet.countFavorite!)
        self.labelCountRetweets.text = String(self.selectedTweet.countRetweet!)
        self.networkController.fetchUserImage(self.selectedTweet, completionHandler: { (imageUser) -> () in
          if imageUser != nil {
          self.buttonImageUser.setBackgroundImage(imageUser, forState: UIControlState.Normal)
          } //end if
        }) //end closure
      } else {
        println(errorString!)
      } //end if
    }) //end closure    
  } //end func
  
  //Function: Display user timeline View Controller when button is clicked.
  @IBAction func buttonUserClicked(sender: AnyObject) {
    //Prepare User timeline View Controller.
    var vcUserTimeline = self.storyboard?.instantiateViewControllerWithIdentifier("VC_USER_TIMELINE") as UserTimelineViewController
    vcUserTimeline.networkController = networkController
    vcUserTimeline.selectedTweet = selectedTweet
    
    //Display View Controller.
    self.navigationController?.pushViewController(vcUserTimeline, animated: true)
  } //end func
}
