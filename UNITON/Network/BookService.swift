//
//  BookService.swift
//  UNITON
//
//  Created by 이광용 on 2018. 1. 28..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation
import Alamofire

struct BookService: APIService {
    static func getData(url: String, method: HTTPMethod,parameter: [String : Any]?, completion: @escaping (Result<Any>)->()) {
        let url = self.getURL(path: url)
        Alamofire.request(url, method: method, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseData { (response) in
            guard let resultData = getResult_StatusCode(response: response) else {return}
            completion(resultData)
        }
    }
    
    static func getSearchData(url: String, parameter: [String : Any]?, completion: @escaping (Result<Any>)->()) {
        let url = self.getURL(path: url)
        Alamofire.request(url, method: .get, parameters: parameter, encoding: URLEncoding.queryString, headers: nil).responseData { (response) in
            guard let resultData = getResult_StatusCode(response: response) else {return}
            completion(resultData)
        }
    }
    
    static func pollyString(url: String, parameter: [String : Any]?, completion: @escaping (Result<Any>)->()) {
        let url = self.getURL(path: url)
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseData { (response) in
            guard let resultData = getResult_StatusCode(response: response) else {return}
            completion(resultData)
        }
    }
    
}
