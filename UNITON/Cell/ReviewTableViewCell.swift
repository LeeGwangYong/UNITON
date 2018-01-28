//
//  ReviewTableViewCell.swift
//  UNITON
//
//  Created by 이광용 on 2018. 1. 27..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var backView: UIView!
    var info: Review? {
        didSet{
            nameLabel.text = "@_\((info?.id)!)"
            contentLabel.text = info?.content
            
            if let isLike = info?.is_like{
                let img = isLike == 1 ? #imageLiteral(resourceName: "HEART") : #imageLiteral(resourceName: "EMPTY_HEART")
                likeButton.setImage(img, for: UIControlState.normal)
            }
            
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
