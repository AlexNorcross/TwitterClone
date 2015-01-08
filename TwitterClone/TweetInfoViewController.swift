//
//  TweetInfoViewController.swift
//  TwitterClone
//
//  Created by Alexandra Norcross on 1/7/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import UIKit

class TweetInfoViewController: UIViewController {
  //Labels: tweet, favorite count
  @IBOutlet weak var labelTweet: UILabel!
  @IBOutlet weak var labelCountFavorite: UILabel!
  
  //Properties: selected Tweet
  var selectedTweet = Tweet()

  //Function: Set View Controller to display Tweet information.
  override func viewDidLoad() {
    //Super:
    super.viewDidLoad()
      
    //Set labels.
    labelTweet.text = selectedTweet.text
    labelCountFavorite.text = String(selectedTweet.countFavorite)
  } //end func
}
