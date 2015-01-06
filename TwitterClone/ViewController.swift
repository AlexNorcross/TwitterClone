//
//  ViewController.swift
//  TwitterClone
//
//  Created by Alexandra Norcross on 1/6/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
  //Table: to display tweets
  @IBOutlet weak var tableTweets: UITableView!
  
  //Array of tweets: to display in table
  var tweets = [Tweet]()
  
  //Function: Set view controller.
  override func viewDidLoad() {
    //Super:
    super.viewDidLoad()
    
    //Load data: from JSON file, containing an array of tweets.
    //  each array unit contains a dictionary containing:
    //    * "text" key (string)
    //    * "user" key > value is dictionary containing:
    //        "name" key (string)
    if let dataFilePath = NSBundle.mainBundle().pathForResource("tweet", ofType: "json") { //file exists
      if let dataFile = NSData(contentsOfFile: dataFilePath) { //data exists
        var errorPointer: NSError?
        if let dataArray = NSJSONSerialization.JSONObjectWithData(dataFile, options: nil, error: &errorPointer) as? [AnyObject] { //data in array
          for dataUnit in dataArray {
            if let dataDictionary = dataUnit as? [String : AnyObject] { //data in dictionary
              let newTweet = Tweet(jsonTweet: dataDictionary)
              tweets.append(newTweet)
            } //end if
          } //end for
        } //end if
      } //end if
    } //end if
    
    //Table view: data source.
    tableTweets.dataSource = self
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
    //Set cell contents:
    cellTweet.labelTweet.text = currentTweet.text
    cellTweet.labelUsername.text = currentTweet.username
    //Return cell.
    return cellTweet
  } //end func
}

