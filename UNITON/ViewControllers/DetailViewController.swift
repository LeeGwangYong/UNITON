//
//  DetailViewController.swift
//  UNITON
//
//  Created by 이광용 on 2018. 1. 27..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var bookNameLabel: TitleLabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var hateLabel: UILabel!
    @IBOutlet weak var reviewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thumbnailImageView.image = #imageLiteral(resourceName: "Sample")
        setUpViewController()
        // Do any additional setup after loading the view.
    }
    func setUpViewController(){
        backgroundImage()
        self.reviewTableView.setUp(target: self, cell: ReviewTableViewCell.self)
        self.navigationItem.title = ""
        
    }
    
    @IBAction func touchUpMore(_ sender: UIButton) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: TotalReviewViewController.reuseIdentifier)
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReviewTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    
}
