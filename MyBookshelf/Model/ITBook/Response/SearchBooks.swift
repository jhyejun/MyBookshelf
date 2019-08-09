//
//  SearchBooks.swift
//  MyBookshelf
//
//  Created by 장혜준 on 07/08/2019.
//  Copyright © 2019 장혜준. All rights reserved.
//

import Foundation

struct SearchBooks: Codable {
    var error, total, page: String
    var books: [Book]
    
    enum CodingKeys: CodingKey {
        case error, total, page
        case books
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(SearchBooks.self, from: data)
    }
}
