//
//  Tweet.swift
//  TwitterClone
//
//  Created by Alexandra Norcross on 1/6/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import UIKit

class Tweet {
  //Properties:
  var id: String
  var text: String
  var userID: String = ""
  var username: String = ""
  var userImageURL: String = ""
  var userImageBackgroundURL: String = ""
  var userLocation: String = ""
  var countFavorite: Int?
  var countRetweet: Int?
  var jsonRetweet: [String : AnyObject]? //JSON of retweet
  
  //Initializer: Sets class properties.
  init (jsonTweet: [String : AnyObject]) {
    //Dictionary contains:
    //    * tweet properties; and
    //    * user properties are in dictionary

    //Tweet:
    id = jsonTweet["id_str"] as String
    text = jsonTweet["text"] as String
    if let jsonRetweet = jsonTweet["retweeted_status"] as? [String : AnyObject] {
      self.jsonRetweet = jsonRetweet
    } //end if

    //User:
    if let user = jsonTweet["user"] as? [String : AnyObject] {
      userID = user["id_str"] as String
      username = user["name"] as String
      if let urlImage = user["profile_image_url"] as? String {
        userImageURL = urlImage
      } //end if
      if let urlImageBackground = user["profile_background_image_url_https"] as? String {
        userImageBackgroundURL = urlImageBackground
      } //end if
      userLocation = user["location"] as String
    } //end if
  } //end init
    
  //Function: Update Tweet with information.
  func updateWithInfo(jsonTweetInfo: [String : AnyObject]) {
    //Favorite count:
    if let count = jsonTweetInfo["favorite_count"] as? Int {
      countFavorite = count
    } //end if
    //Retweet count:
    if let count = jsonTweetInfo["retweet_count"] as? Int {
      countRetweet = count
    } //end if
  } //end func
  
  //Function: Return Tweet's retweet.
  func fetchRetweet(_currentTweet: Tweet) -> Tweet? {
    if jsonRetweet != nil {
      return Tweet(jsonTweet: jsonRetweet!)
    } else {
      return nil
    } //end if
  } //end func
}