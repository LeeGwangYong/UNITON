//
//  Book.swift
//  UNITON
//
//  Created by 이광용 on 2018. 1. 28..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation

struct Book: Codable {
    let title: String
    let link: String?
    let image: String
    let author: String
    let price: String?
    let discount: String?
    let publisher: String?
    let pubdate: String?
    let isbn: String
    let description: String?
}

