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
        self.recommendCollectionView.setUp(target: self, cell: RecommendCollectionViewCell.self)
        self.reviewTableView.setUp(target: self, cell: ReviewTableViewCell.self)
        self.reviewTableView.alwaysBounceVertical = false
        self.recommendCollectionView.alwaysBounceHorizontal = false
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.reuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.bounds.width
        
        return CGSize(width: (width - 60) / 2, height: collectionView.bounds.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.reuseIdentifier, for: indexPath)
        return cell
    }
}

