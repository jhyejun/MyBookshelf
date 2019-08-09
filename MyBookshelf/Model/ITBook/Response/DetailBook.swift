//
//  DetailBook.swift
//  MyBookshelf
//
//  Created by 장혜준 on 09/08/2019.
//  Copyright © 2019 장혜준. All rights reserved.
//

import Foundation

struct DetailBook: Codable {
    let error, title, subtitle, authors: String
    let publisher, language, isbn10, isbn13: String
    let pages, year, rating, desc: String
    let price, image, url: String
    
    enum CodingKeys: CodingKey {
        case error, title, subtitle, authors
        case publisher, language, isbn10, isbn13
        case pages, year, rating, desc
        case price, image, url
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(DetailBook.self, from: data)
    }
}

