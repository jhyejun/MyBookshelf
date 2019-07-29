//
//  Book.swift
//  MyBookshelf
//
//  Created by 장혜준 on 29/07/2019.
//  Copyright © 2019 장혜준. All rights reserved.
//

import Foundation

struct Book: Codable {
    let title, subtitle, isbn13, price, image, url: String
    
    enum CodingKeys: CodingKey {
        case title, subtitle, isbn13, price, image, url
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(Book.self, from: data)
    }
}
