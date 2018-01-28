//
//  MyViewController.swift
//  UNITON
//
//  Created by 이광용 on 2018. 1. 28..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyViewController: UIViewController {
    @IBOutlet weak var reviewTableView: UITableView!
    var reviews: [Review] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
    }
    
    func setUpViewController() {
        transparentNavigationBar()
        backgroundImage()
        reviewTableView.backgroundColor = UIColor.clear
        
        self.reviewTableView.setUp(target: self, cell: MyReviewTableViewCell.self)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchGetMyReview()
    }
    
    func fetchGetMyReview() {
        ReviewService.getData(url: "get_my_review", method: .post, parameter: Token.getToken()) { (result) in
            switch result {
            case .Success(let response):
                guard let data = response as? Data else {return}
                let dataJSON = JSON(data)
                print(dataJSON)
                if dataJSON["code"] == "9999"{
                    let responseJSON = dataJSON["response"]
                    let decoder = JSONDecoder()
                    do {
                        self.reviews = try decoder.decode([Review].self, from: responseJSON.rawData())
                        self.reviewTableView.reloadData()
                    }
                    catch (let err) {
                        print(err.localizedDescription)
                    }
                }
                else {
                    self.reviews = []
                    self.reviewTableView.reloadData()
                }
            case .Failure(let failureCode):
                print("My Review is Failure : \(failureCode)")
                self.reviews = []
                self.reviewTableView.reloadData()
                //                switch failureCode {
                //                case ... :
                //                }
            }
        }
    }
    
    func fetchRemoveReview(isbn: String) {
        ReviewService.removeData(url: "remove_review", method: .put, parameter: ["id" : Token.getToken()["id"], "isbn" :  isbn]) { (result) in
            switch result {
            case .Success(let response):
                guard let data = response as? Data else {return}
                let dataJSON = JSON(data)
                print(dataJSON)
                self.fetchGetMyReview()
            case .Failure(let failureCode):
                print("My Review is Failure : \(failureCode)")
            }
            
        }
    }
    
    func input(indexPath: IndexPath) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ReviewInputViewController.reuseIdentifier) as! ReviewInputViewController
        nextVC.review = reviews[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        UserDefaults.standard.removeObject(forKey: "id")
        self.parent?.dismiss(animated: true, completion: nil)
    }
}




extension MyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "삭제하기") { (deleteAction, indexPath) in
            //Contact.removeFromRealm(self.contactArray[indexPath.row])
            self.fetchRemoveReview(isbn: self.reviews[indexPath.row].isbn)
            
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "수정하기") { (editAction, indexPath) in
            self.hidesBottomBarWhenPushed = true
            self.input(indexPath: indexPath)
            self.hidesBottomBarWhenPushed = false
        }
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyReviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: MyReviewTableViewCell.reuseIdentifier, for: indexPath) as! MyReviewTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.info = reviews[indexPath.row]
        return cell
    }
    //
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return 18
    //    }
    
}
