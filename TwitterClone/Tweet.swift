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
  var username: String = ""
  var id: String = ""
  var text: String = ""
  var countFavorite: Int = 0
  var userImageURL: String = ""
  
  //Initializer: blank
  init() {
    
  } //end init
  
  //Initializer: Sets class properties.
  init (jsonTweet: [String : AnyObject]) {
    //Dictionary contains:
    //    * id at: "id_str" key
    //    * text at: "text" key
    //    * "user" key > value is dictionary containing:
    //        username at: "name" key
    //        image url at: "profile_image_url"
    
    //User: name and image
    if let user = jsonTweet["user"] as? [String : AnyObject] {
      username = user["name"] as String
      if let imageURL = user["profile_image_url"] as? String {
        userImageURL = imageURL
      } //end if
    } //end if
    
    //Id:
    id = jsonTweet["id_str"] as String
    
    //Text:
    text = jsonTweet["text"] as String
  } //end init
}