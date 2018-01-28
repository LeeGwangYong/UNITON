//
//  MyReviewTableViewCell.swift
//  UNITON
//
//  Created by 이광용 on 2018. 1. 28..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import Kingfisher

class MyReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    var info: Review? {
        didSet {
            self.bookNameLabel.text = info?.title
            self.writerLabel.text = info?.author
        
            if let url = info?.image {
                self.thumbnailImageView.kf.indicatorType = .activity
                self.thumbnailImageView.kf.setImage(with: URL(string: url))
            }
            reviewLabel.text = info?.content
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
