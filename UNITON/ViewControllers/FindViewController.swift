//
//  FindViewController.swift
//  UNITON
//
//  Created by 이광용 on 2018. 1. 27..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import SwiftyJSON

class FindViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
    }
    func setUpViewController(){
        transparentNavigationBar()
        searchBarTopConstraint.constant = 100
        self.searchBar.delegate = self
        self.resultCollectionView.setUp(target: self, cell: FindCollectionViewCell.self)
        self.resultCollectionView.keyboardDismissMode = .onDrag
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func constraintUp(value: Bool) {
        
        
        UIView.animate(withDuration: 0.3) {
            if value {self.searchBarTopConstraint.constant = 0}
            else {self.searchBarTopConstraint.constant = 100}
            self.view.layoutIfNeeded()
        }
    }
    
    func fetchGetBooks(str: String) {
    
        
        BookService.getSearchData(url: "search_book/search/book/", parameter: ["query" : str], completion: { (result) in
            switch result {
            case .Success(let response):
                guard let data = response as? Data else {return}
                let dataJSON = JSON(data)
                print(dataJSON)
                let responseJSON = dataJSON["items"]
                let decoder = JSONDecoder()
                do {
                    self.books = try decoder.decode([Book].self, from: responseJSON.rawData())
                    self.resultCollectionView.reloadData()
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
        })
    }
}

extension FindViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FindCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.info = books[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width/2
        let height = collectionView.bounds.height/2
        return CGSize(width: width - 10, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 0, bottom: 32, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: DetailViewController.reuseIdentifier) as! DetailViewController
        nextVC.bookData = books[indexPath.row]
        
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}

extension FindViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            constraintUp(value: true)
        }
        else {
            constraintUp(value: false)
            self.books = []
            self.resultCollectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            fetchGetBooks(str: text)
        }
    }
}

