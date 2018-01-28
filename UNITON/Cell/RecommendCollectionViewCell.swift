//
//  RecommendCollectionViewCell.swift
//  UNITON
//
//  Created by 이광용 on 2018. 1. 27..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class RecommendCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var bookNameLabel: UILabel!
    var info: Book? {
        didSet {
            if let url = info?.image {
                thumbnailImageView.kf.indicatorType = .activity
                thumbnailImageView.kf.setImage(with: URL(string: url))
            }
            bookNameLabel.text = info?.title   
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
