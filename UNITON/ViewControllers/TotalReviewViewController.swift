//
//  TotalReviewViewController.swift
//  UNITON
//
//  Created by 이광용 on 2018. 1. 27..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toast_Swift

class TotalReviewViewController: UIViewController {
    @IBOutlet weak var reviewTableView: UITableView!
    var reviews: [Review]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reviewTableView.setUp(target: self, cell: ReviewTableViewCell.self)
        self.navigationItem.title = "전체 리뷰"
        backgroundImage()
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
                //                switch failureCode {
                //                case ... :
                //                }
            }
        }
    }

}

extension TotalReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReviewTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.info = reviews[indexPath.row]
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeAction(_:)), for: .touchUpInside)
        return cell
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
