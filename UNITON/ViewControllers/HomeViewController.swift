//
//  HomeViewController.swift
//  UNITON
//
//  Created by 이광용 on 2018. 1. 27..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toast_Swift

class HomeViewController: UIViewController {
    //MARK -: Properties
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    var recommendedBooks:[Book] = []
    var reviews: [Review] = []
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
        self.navigationItem.title = "홈"
        let icon = #imageLiteral(resourceName: "ICON")
        let imageView = UIImageView(image:icon)
        self.navigationItem.titleView = imageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchGetRecommendedBooks()
        fetchGetBestReviews()
        
    }
    
    func fetchGetRecommendedBooks() {
        BookService.getData(url: "recommend_book", method: .get, parameter: nil) { (result) in
            switch result {
            case .Success(let response):
                guard let data = response as? Data else {return}
                let dataJSON = JSON(data)
                print(dataJSON)
                let responseJSON = dataJSON["response"]
                let decoder = JSONDecoder()
                do {
                    self.recommendedBooks = try decoder.decode([Book].self, from: responseJSON.rawData())
                    self.recommendCollectionView.reloadData()
                }
                catch (let err) {
                    print(err.localizedDescription)
                }
            case .Failure(let failureCode):
                print("My Review is Failure : \(failureCode)")
                //                switch failureCode {
                //                case ... :
                //                }
            }
        }
    }
    
    func fetchGetBestReviews() {
        ReviewService.getData(url: "great_review", method: .post, parameter: Token.getToken()) { (result) in
            switch result {
            case .Success(let response):
                guard let data = response as? Data else {return}
                let dataJSON = JSON(data)
                print(dataJSON)
                let responseJSON = dataJSON["response"]
                let decoder = JSONDecoder()
                do {
                    self.reviews = try decoder.decode([Review].self, from: responseJSON.rawData())
                    self.reviewTableView.reloadData()
                }
                catch (let err) {
                    print(err.localizedDescription)
                }
            case .Failure(let failureCode):
                print("My Review is Failure : \(failureCode)")
            }
        }
    }
    
    func fetchGetLikeData(url: String, parameter: [String: Any], index: Int) {
        ReviewService.likeData(url: url, method: .put, parameter: parameter) {  (result) in
            switch result {
            case .Success(let response):
                guard let data = response as? Data else {return}
                let dataJSON = JSON(data)
                print(dataJSON)
                let like = self.reviews[index].is_like
                if like == 1 {
                    self.reviews[index].is_like = 0
                    self.view.makeToast("이 조각은 나와 맞지않아요.", duration: 1, position: ToastPosition.center, title: nil, image: nil, style: ToastStyle.init(), completion: nil)
                }
                else {
                    self.reviews[index].is_like = 1
                    self.view.makeToast("이 조각은 내 생각과 맞아요.", duration: 1, position: ToastPosition.center, title: nil, image: nil, style: ToastStyle.init(), completion: nil)
                }
                
                
                self.reviewTableView.reloadData()
            case .Failure(let failureCode):
                print("My Review is Failure : \(failureCode)")
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.reuseIdentifier, for: indexPath) as! RecommendCollectionViewCell
        cell.info = recommendedBooks[indexPath.row]
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
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: DetailViewController.reuseIdentifier) as! DetailViewController
        nextVC.bookData = recommendedBooks[indexPath.row]
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //Horiznotal Card Paging
        if scrollView == self.recommendCollectionView {
            let width = self.recommendCollectionView.frame.width -  60
            let pageWidth: Float = Float( width / 2  +  30  ) //(Paging Item Size) + (Minimum spacing)
            
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
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.reuseIdentifier, for: indexPath) as! ReviewTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.info = reviews[indexPath.row]
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeAction(_:)), for: .touchUpInside)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: DetailViewController.reuseIdentifier) as! DetailViewController
        nextVC.bookData = self.recommendedBooks[indexPath.row]
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    
    @IBAction func likeAction(_ sender: UIButton){
        let id = reviews[sender.tag].id
        let member_id = Token.getToken()["id"]
        let url = reviews[sender.tag].is_like == 1 ? "remove_like" : "push_like"
        
        let parameter: [String : Any] = ["id": id,
                                         "isbn" : reviews[sender.tag].isbn,
                                         "member_id" : member_id]
        
        fetchGetLikeData(url: url, parameter: parameter, index: sender.tag)
        
    }
}

