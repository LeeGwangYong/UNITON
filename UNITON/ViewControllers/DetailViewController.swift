//
//  DetailViewController.swift
//  UNITON
//
//  Created by 이광용 on 2018. 1. 27..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toast_Swift
import AVFoundation
import AWSPolly
import Lottie

class DetailViewController: UIViewController {
    @IBOutlet weak var bookNameLabel: TitleLabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var hateLabel: UILabel!
    @IBOutlet weak var reviewTableView: UITableView!
    
//    "voice" : "신경 끄기의 기술 을 읽은 다른 사람들은 조금 즐거워했어요.",
    
    var bookData: Book!
    var reviews: [Review] = []
    var audioPlayer = AVPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thumbnailImageView.image = #imageLiteral(resourceName: "Sample")
        bookNameLabel.text = bookData.title.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
        writerLabel.text = bookData.author
        thumbnailImageView.kf.setImage(with: URL(string: bookData.image))
        
        setUpViewController()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchGetReview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        audioPlayer.pause()
    }
    
    func setUpViewController(){
        backgroundImage()
        self.reviewTableView.setUp(target: self, cell: ReviewTableViewCell.self)
        self.navigationItem.title = ""
        fetchPollyString()
    }
    
    @IBAction func touchUpMore(_ sender: UIButton) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: TotalReviewViewController.reuseIdentifier) as! TotalReviewViewController
        nextVC.reviews = self.reviews
        
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func touchUpReview(_ sender: Any) {
        let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ReviewInputViewController.reuseIdentifier) as! ReviewInputViewController
        nextVC.bookData = bookData
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func fetchGetReview() {
        ReviewService.getData(url: "ios_create_review", method: .post, parameter: ["isbn" : bookData.isbn,
                                                                                 "member_id" : Token.getToken()["id"]]) { (result) in
            switch result {
            case .Success(let response):
                guard let data = response as? Data else {return}
                let dataJSON = JSON(data)
                print(dataJSON)
                let responseJSON = dataJSON["response"]
                self.reviewLabel.text =  String(describing: responseJSON["total"].int ?? 0)
                self.likeLabel.text = String(describing: responseJSON["like"].int ?? 0)
                self.hateLabel.text = String(describing: responseJSON["hate"].int ?? 0)
                let reviewJSON = dataJSON["review"]
                
                let decoder = JSONDecoder()
                do {
                    self.reviews = try decoder.decode([Review].self, from: reviewJSON.rawData())
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
        ReviewService.getData(url: url, method: .put, parameter: parameter) {  (result) in
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
    
    let animationView = LOTAnimationView(name: "empty_list")
    func fetchPollyString() {
        BookService.pollyString(url: "ios_polly", parameter: ["isbn" : bookData.isbn]) { (result) in
            switch result {
            case .Success(let response):
                guard let data = response as? Data else {return}
                let dataJSON = JSON(data)
                print(dataJSON)
                if let str = dataJSON["voice"].string {
                    AWSPolly_TTS.continueSpeach(audioPlayer: self.audioPlayer, text: "\(str)")
                    

                    
                    self.animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                    self.animationView.contentMode = .scaleAspectFill
                    self.animationView.frame = CGRect(x: self.view.bounds.width - 100,
                                                 y: self.view.bounds.height - 100, width: 100, height: 100)
                    self.self.view.addSubview(self.animationView)
                    self.animationView.play()
                    self.animationView.loopAnimation = true
                    self.perform(#selector(self.hiddenLottie), with: nil, afterDelay: 5)
                    
                }
            case .Failure(let failureCode):
                print("My Review is Failure : \(failureCode)")
                //                switch failureCode {
                //                case ... :
                //                }
            }        }
    }
    
    @objc func hiddenLottie() {
        animationView.isHidden = true
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reviews.count < 5 {
            return reviews.count
        }
        return 5
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
