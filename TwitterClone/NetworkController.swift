//
//  NetworkController.swift
//  TwitterClone
//
//  Created by Alexandra Norcross on 1/7/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import Foundation
import Accounts
import Social

class NetworkController {
  //Twitter account:
  var accountTwitter: ACAccount?
  
  //Twitter user image thread:
  var threadTwitterUser = NSOperationQueue()
  
  //Cache of user images:
  var imagesUsers = [String : UIImage]()
  
  //Initializer: blank
  init() {

  } //end init
  
  //Function: Access Twitter account to retrieve account user's timelime.
  func fetchHomeTimeline(completionHandler: ([Tweet]?, String?) -> ()) {
    //Store & Type:
    var accountStore = ACAccountStore()
    var accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)

    //Request access to Twitter account and handle callback.
    accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (accessGranted, errorHandler) -> Void in
      if accessGranted { //access granted
        //Retrieve Twitter accounts.
        let accountsTwitter = accountStore.accountsWithAccountType(accountType) as [ACAccount]
        if !accountsTwitter.isEmpty { //access first account
          //First Twitter account:
          self.accountTwitter = accountsTwitter.first
          
          //Set up request for timeline: url, request, and account
          let urlTimeline = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
          let requestTimeline = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: urlTimeline, parameters: nil)
          requestTimeline.account = self.accountTwitter
          
          //Perform request and load JSON data, if there were no errors.
          requestTimeline.performRequestWithHandler({ (jsonData, urlResponse, errorHandler) -> Void in
            switch urlResponse.statusCode {
            
            case 200...299: //successful request: parse JSON file
              //JSON file contains an array of tweets.
              //  each array unit contains a dictionary containing:
              //    * tweets
              //    * user information in a dictionary
              var errorPointer: NSError?
              if let dataArray = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &errorPointer) as? [AnyObject] {
                
                //Add tweets in JSON data to Tweets array.
                var tweets = [Tweet]()
                for dataUnit in dataArray {
                  if let dataDictionary = dataUnit as? [String : AnyObject] {
                    let newTweet = Tweet(jsonTweet: dataDictionary)
                    tweets.append(newTweet)
                  } //end if
                } //end for
                
                //Return to main thread and call completion handler.
                NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                  completionHandler(tweets, nil)
                } //end closure
              } //end if
            
            default: //error
              completionHandler(nil, "Twitter account error occurred")
            } //end switch
          }) //end closure
        
        } else { //no accounts exist
          completionHandler(nil, "no existing Twitter account")
        } //end if
      
      } else { //access not granted
        completionHandler(nil, "access to Twitter not granted")
      } //end else
    } //end closure
  } //end func
    
  //Function: Retrieves Twitter user image on new thread.
  func fetchUserImage(tweet: Tweet, completionHandler: (UIImage?) -> ()) {
    let userID = tweet.userID
    if self.imagesUsers[userID] != nil { //return image from cache
      completionHandler(self.imagesUsers[userID])
    } else { //retrieve image
      let urlImageString = tweet.userImageURL
      if urlImageString != "" {
        if let urlImage = NSURL(string: urlImageString) {
          threadTwitterUser.addOperationWithBlock({ () -> Void in
            if let dataImage = NSData(contentsOfURL: urlImage) {
              //Image:
              let userImage = UIImage(data: dataImage)
              
              //Add user image to image cache.
              if userImage != nil {
                self.imagesUsers[userID] = userImage
              } //end if
              
              //Return to main thread and call completion handler.
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(userImage)
              }) //end closure
            } //end if
          }) //end closure
        } //end if
      } //end if
    } //end if
  } //end func

  //Function: Retrieves Twitter user background image on new thread.
  func fetchUserBackgroundImage(userID: String, urlImage: String, completionHandler: (UIImage?) -> ()) {
    if urlImage != "" {
      if let urlImage = NSURL(string: urlImage) {
        threadTwitterUser.addOperationWithBlock({ () -> Void in
          if let dataImage = NSData(contentsOfURL: urlImage) {
            //Image:
            let userImage = UIImage(data: dataImage)
            //Return to main thread and call completion handler.
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              completionHandler(userImage)
            }) //end closure
          } //end if
        }) //end closure
      } //end if
    } //end if
  } //end func

  //Function: Access tweet to retrieve tweet infomation.
  func fetchTweetInfo(idTweet: String, completionHandler: ([String : AnyObject]?, String?) -> ()) {
    //Setup request for tweet: url, request, and account.
    let urlTweetInfo = NSURL(string: "https://api.twitter.com/1.1/statuses/show.json?id=\(idTweet)")
    let requestTweetInfo = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: urlTweetInfo, parameters: nil)
    requestTweetInfo.account = self.accountTwitter
    
    //Perform request and load JSON data, if there were no errors.
    requestTweetInfo.performRequestWithHandler {(jsonData, urlResponse, errorHandler) -> Void in
      switch urlResponse.statusCode {
        
      case 200...299: //successful request: parse JSON file
        //JSON file contains a dictionary.
        var errorPointer: NSError?
        if let dataDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &errorPointer) as? [String : AnyObject] {
          //Return to main thread and call completion handler.
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(dataDictionary, nil)
          }) //end closure
        } //end if
        
      default: //error
        completionHandler(nil, "Tweet information error occurred")
      } //end switch
    } //end closure
  } //end func
  
  //Function: Access user timeline.
  func fetchUserTimeline(userID: String, completionHandler: ([Tweet]?, String?) -> ()) {
    //Setup request for user timeline: url, request, and account.
    let urlTimeline = NSURL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json?user_id=\(userID)")
    let requestTimeline = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: urlTimeline, parameters: nil)
    requestTimeline.account = self.accountTwitter
    
    //Perform request and load JSON data, if there were no errors.
    requestTimeline.performRequestWithHandler {(jsonData, urlResponse, errorHandler) -> Void in
      switch urlResponse.statusCode {
      
      case 200...299:
        //JSON file contains an array of tweets.
        //  each array unit contains a dictionary containing:
        //    * tweets
        //    * user information in a dictionary
        var errorPointer: NSError?
        if let dataArray = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &errorPointer) as? [AnyObject] {
          
          //Add tweets in JSON data to Tweets array.
          var tweets = [Tweet]()
          for dataUnit in dataArray {
            if let dataDictionary = dataUnit as? [String : AnyObject] {
              let newTweet = Tweet(jsonTweet: dataDictionary)
              tweets.append(newTweet)
            } //end if
          } //end for
          
          //Return to main thread and call completion handler.
          NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            completionHandler(tweets, nil)
          } //end closure
        } //end if
      
      default: //error
        completionHandler(nil, "User timeline error occured")
      } //end switch
    } //end closure
  } //end func  
}