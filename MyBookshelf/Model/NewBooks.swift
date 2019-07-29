//
//  NewBooks.swift
//  MyBookshelf
//
//  Created by 장혜준 on 29/07/2019.
//  Copyright © 2019 장혜준. All rights reserved.
//

import Foundation

struct NewBooks: Codable {
    let error, total: String
    let books: [Book]
    
    enum CodingKeys: CodingKey {
        case error, total
        case books
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(NewBooks.self, from: data)
    }
}
