//
//  ReviewStruct.swift
//  UNITON
//
//  Created by 이광용 on 2018. 1. 28..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation

struct Review: Codable {
    let content: String
    let _id: String?
    let id: String
    let image: String?
    let score: Double?
    let like: [[String:String]]?
    let __v: Int?
    let date: String?
    let title: String?
    let author: String?
    let isbn: String
    let like_cnt: Int?
    var is_like: Int?
}

