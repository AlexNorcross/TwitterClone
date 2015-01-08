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
  
  //Initializer: blank
  init() {
    
  } //end init
  
  //Function: Accesses Twitter account to retrieve user timelime.
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
          
          //Perform request and handle callback.
          requestTimeline.performRequestWithHandler({ (jsonData, urlResponse, errorHandler) -> Void in
            //Check URL response. Handle errors, if any.
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
            
            default: //error occurred: handle error
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
  
  //Function: Accesses tweet to retrieve tweet infomation.
  func fetchTweetInfo(idTweet: String, keyTweetInfo: String, completionHandler: (Int?, String?) -> ()) {
    //Setup request for tweet: url, request, and account.
    let urlTweetInfo = NSURL(string: "https://api.twitter.com/1.1/statuses/show.json?id=\(idTweet)")
    let requestTweetInfo = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: urlTweetInfo, parameters: nil)
    requestTweetInfo.account = self.accountTwitter
    
    //Perform request and handle callback.
    requestTweetInfo.performRequestWithHandler {(jsonData, urlResponse, errorHandler) -> Void in
      //Check URL response. Handle errors, if any.
      switch urlResponse.statusCode {
      
      case 200...299: //successful request: parse JSON file
        //JSON file contains a dictionary.
        var errorPointer: NSError?
        if let dataDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &errorPointer) as? [String : AnyObject] {
          //Return to main thread and call completion handler.
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            if let infoTweet = dataDictionary[keyTweetInfo] as? Int {
              completionHandler(infoTweet, nil)
            } //end if
          }) //end closure
        } //end if
      
      default: //error occurred: handle error
        completionHandler(nil, "Tweet error occurred")
      } //end switch
    } //end closure
  } //end func
}