//
//  SearchBooks.swift
//  MyBookshelf
//
//  Created by 장혜준 on 07/08/2019.
//  Copyright © 2019 장혜준. All rights reserved.
//

import Foundation

struct SearchBooks: Codable {
    let error, total, page: String
    let books: [Book]
    
    enum CodingKeys: CodingKey {
        case error, total, page
        case books
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(SearchBooks.self, from: data)
    }
}
