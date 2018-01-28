//
//  InputViewController.swift
//  UNITON
//
//  Created by 이광용 on 2018. 1. 28..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVFoundation
import AWSPolly
import Toast_Swift
import Lottie

class ReviewInputViewController: UIViewController {
    
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var textCountLable: UILabel!
    var barButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveReview))
    var bookData:Book?
    var review: Review?
    var audioPlayer = AVPlayer()
    var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
    }
    
    
    func setUpViewController() {
        transparentNavigationBar()
        backgroundImage()
        self.title = "리뷰작성"
        
        if let bookData = bookData {
            bookNameLabel.text = bookData.title.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
            writerLabel.text = bookData.author
        }
        
        if let review = review {
            bookNameLabel.text = review.title!.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
            writerLabel.text = review.author
            contentTextView.text = review.content
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        dateLabel.text = formatter.string(from: Date())
        
        self.navigationItem.rightBarButtonItem = barButton
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.contentTextView.delegate = self
        
    }
    
    @objc func saveReview(){
        var parameter: [String : Any] = [:]
        var url = ""
        if let bookData = bookData {
            parameter = ["id" : Token.getToken()["id"],
                         "title" : bookData.title,
                         "isbn" : bookData.isbn,
                         "author" : bookData.author,
                         "image" : bookData.image,
                         "content" : contentTextView.text]
            url = "create_review"
        }
        
        if let review = review {
            parameter = ["id" : Token.getToken()["id"],
                         "isbn" : review.isbn,
                         "content" : contentTextView.text]
            url = "update_review"
        }
        
        ReviewService.getData(url: url, method: .post, parameter: parameter, completion: { (result) in
            switch result {
            case .Success(let response):
                guard let data = response as? Data else {return}
                let dataJSON = JSON(data)
                if dataJSON["code"] == "9999" {
                    self.view.makeToast("조각이 공유되었어요.", duration: 1, position: .center, title: nil, image: nil, style: ToastStyle.init(), completion: { (bool) in
                        if self.bookData != nil {
                            self.navigationItem.rightBarButtonItem?.isEnabled = false
                            self.fetchPollyString(book: self.bookData!)
                        }
                        else {
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
                }
                else {
                    self.view.makeToast("조각이 공유가 실패하였어요.", duration: 1, position: .center, title: nil, image: nil, style: ToastStyle.init(), completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            case .Failure(let failureCode):
                print("My Review is Failure : \(failureCode)")
            }
        })
    }
    
    
    

    
    func fetchPollyString(book: Book) {
        
        BookService.pollyString(url: "call_polly", parameter: ["isbn" : book.isbn,
                                                              "id" : Token.getToken()["id"]]) { (result) in
            switch result {
            case .Success(let response):
                guard let data = response as? Data else {return}
                let dataJSON = JSON(data)
                print(dataJSON)
                if let str = dataJSON["voice"].string {
                    AWSPolly_TTS.continueSpeach(audioPlayer: self.audioPlayer, text: "\(str)")
                    self.view.endEditing(true)
                    
                    self.backView = UIView(frame: self.view.frame)
                    self.backView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                    let animationView = LOTAnimationView(name: "empty_list")
                    animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                    animationView.contentMode = .scaleAspectFill
                    animationView.frame = CGRect(x: self.view.bounds.width - 100,
                                                 y: self.view.bounds.height - 100, width: 100, height: 100)
                    animationView.tintColor = UIColor.white
                    self.backView.addSubview(animationView)
                    self.view.addSubview(self.backView)
                    animationView.play()
                    animationView.loopAnimation = true
                    self.perform(#selector(ReviewInputViewController.popViewController), with: nil, afterDelay: 5)
                }
                else {
                    self.navigationController?.popViewController(animated: true)
                }
            case .Failure(let failureCode):
                self.navigationController?.popViewController(animated: true)
                print("My Review is Failure : \(failureCode)")
            }
        }
    }
    
    @objc func popViewController() {
        backView.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }
}

extension ReviewInputViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        print(numberOfChars)
        textCountLable.text = "(\(String(describing: numberOfChars))/150)"
        if numberOfChars < 150 {
            return true
        }
        else {
            textView.shake(10)
            return false
        }
    }
}

extension UIView
{
    public func shake(_ value: Double) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-value, value, -value*(2/3), value*(2/3), -value*(1/3), value*(1/3), 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
