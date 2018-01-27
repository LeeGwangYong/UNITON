//
//  HomeViewController.swift
//  UNITON
//
//  Created by 이광용 on 2018. 1. 27..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {
    //MARK -: Properties
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK -: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
    }
    
    func setUpViewController() {
        
        backgroundImage()
        transparentNavigationBar()
        self.recommendCollectionView.setUp(target: self, cell: RecommendCollectionViewCell.self)
        self.reviewTableView.setUp(target: self, cell: ReviewTableViewCell.self)
        self.pageControl.isEnabled = false
        self.reviewTableView.alwaysBounceVertical = false
        self.reviewTableView.backgroundColor = UIColor.clear
        self.recommendCollectionView.alwaysBounceHorizontal = false
        self.navigationItem.title = ""
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.reuseIdentifier, for: indexPath) as! RecommendCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.bounds.width
        
        return CGSize(width: (width - 60) / 2, height: collectionView.bounds.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let width = collectionView.bounds.width -  60
        return UIEdgeInsetsMake(0, width / 3 * 1.1, 0, width / 3 * 1.1); // top, left, bottom, right
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: DetailViewController.reuseIdentifier)
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == self.recommendCollectionView {
            var width = self.recommendCollectionView.frame.width -  60
//            ( width * 1.2 - width ) / 2
            let pageWidth: Float = Float( width / 2  +  30  ) //480 + 50
            // width + space
            let currentOffset: Float = Float(scrollView.contentOffset.x)
            let targetOffset: Float = Float(targetContentOffset.pointee.x)
            var newTargetOffset: Float = 0
            if targetOffset > currentOffset {
                newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth
            }
            else {
                newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth
            }
            if newTargetOffset < 0 {
                newTargetOffset = 0
            }
            else if (newTargetOffset > Float(scrollView.contentSize.width)){
                newTargetOffset = Float(Float(scrollView.contentSize.width))
            }
            
            targetContentOffset.pointee.x = CGFloat(currentOffset)
            scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: scrollView.contentOffset.y), animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let currentIndex = self.recommendCollectionView.detectCurrentCellIndexPath() {
            self.pageControl.currentPage = currentIndex.row
            self.recommendCollectionView.currentCell().animateZoomforCell()
            
            for index in self.recommendCollectionView.indexPathsForVisibleItems {
                let cell: RecommendCollectionViewCell = self.recommendCollectionView.cellForItem(at: index) as! RecommendCollectionViewCell
                if index == currentIndex {
                    cell.animateZoomforCell()
                    cell.bookNameLabel.alpha = 1
                }
                else {
                    self.recommendCollectionView.cellForItem(at: index)?.animateZoomforCellremove()
                    cell.bookNameLabel.alpha = 0
                }
            }
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.reuseIdentifier, for: indexPath) as! ReviewTableViewCell
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    
}

