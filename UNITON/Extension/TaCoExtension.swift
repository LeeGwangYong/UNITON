//
//  TaCoExtension.swift
//  UNITON
//
//  Created by 이광용 on 2018. 1. 26..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation
import UIKit


extension UITableView  {
    func setUp(target: UITableViewDelegate & UITableViewDataSource, cell: UITableViewCell.Type) {
        self.delegate = target
        self.dataSource = target
        self.separatorStyle = .none
        self.register(UINib(nibName: cell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: cell.reuseIdentifier)
    }

    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

extension UICollectionViewCell {
    func animateZoomforCell()
    {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: UIViewAnimationOptions.curveEaseOut,
            animations: {
                self.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        },
            completion: nil)
    }
    func animateZoomforCellremove()
    {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: UIViewAnimationOptions.curveEaseOut,
            animations: {
                self.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        },
            completion: nil)
        
    }
}

extension UICollectionView {
    func setUp(target: UICollectionViewDelegate & UICollectionViewDataSource, cell: UICollectionViewCell.Type){
        self.delegate = target
        self.dataSource = target
        self.register(UINib(nibName: cell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: cell.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
