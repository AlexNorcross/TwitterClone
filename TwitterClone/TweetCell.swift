//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Alexandra Norcross on 1/6/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import UIKit


class TweetCell: UITableViewCell {
  //Cell features: tweet and username labels; user image
  @IBOutlet weak var labelTweet: UILabel!
  @IBOutlet weak var labelUsername: UILabel!
  @IBOutlet weak var imageUser: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
