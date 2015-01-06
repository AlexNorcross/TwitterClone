//
//  Tweet.swift
//  TwitterClone
//
//  Created by Alexandra Norcross on 1/6/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import Foundation

class Tweet {
  //Properties:
  var username: String
  var text: String
  
  //Initializer: Sets class properties.
  init (jsonTweet: [String : AnyObject]) {
    //User of tweet:
    if let user = jsonTweet["user"] as? [String : AnyObject] {
      self.username = user["name"] as String
    } else {
      self.username = ""
    } //end if
    
    //Text of tweet:
    self.text = jsonTweet["text"] as String
  } //end init
}