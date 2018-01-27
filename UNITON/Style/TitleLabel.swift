//
//  TitleLabel.swift
//  UNITON
//
//  Created by 이광용 on 2018. 1. 27..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

@IBDesignable
class TitleLabel: UILabel {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    func commonInit(){
        self.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        
        self.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 120/255)
    }
 

}
