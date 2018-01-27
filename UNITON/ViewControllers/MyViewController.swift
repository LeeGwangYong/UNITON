//
//  MyViewController.swift
//  UNITON
//
//  Created by 이광용 on 2018. 1. 28..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {
    @IBOutlet weak var reviewTableView: UITableView!
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
    
}

extension MyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "삭제하기") { (deleteAction, indexPath) in
            //Contact.removeFromRealm(self.contactArray[indexPath.row])
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "수정하기") { (editAction, indexPath) in
            
        }
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyReviewTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.backgroundColor = UIColor.clear
        return cell
    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 18
//    }
    
}
