//
//  DetectCurrentCell.swift
//  UNITON
//
//  Created by 이광용 on 2018. 1. 27..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func detectCurrentCellIndexPath() -> IndexPath? {
        var visibleRect = CGRect()
        visibleRect.origin = self.contentOffset
        visibleRect.size = self.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        if let visibleIndexPath: IndexPath = self.indexPathForItem(at: visiblePoint) {
            //print(visibleIndexPath)
            return visibleIndexPath
        }
        
        return nil
    }
    
    func currentCell() -> UICollectionViewCell {
        if let currentInex = self.detectCurrentCellIndexPath(), let cell = self.cellForItem(at: currentInex) {
            return cell
        }
        return UICollectionViewCell()
    }
}
