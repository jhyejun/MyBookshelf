//
//  ITBook.swift
//  MyBookshelf
//
//  Created by 장혜준 on 31/07/2019.
//  Copyright © 2019 장혜준. All rights reserved.
//

import Foundation

enum ITBook: NetworkRequest {
    case new
    case search(query: String, page: String?)
    case detailBook(isbn: String)
}

extension ITBook {
    private var baseUrl: String {
        return "https://api.itbook.store/1.0"
    }
    private var path: String {
        switch self {
        case .new:
            return "/new"
            
        case .search:
            return "/search"
            
        case .detailBook:
            return "/books"
        }
    }
    private var defaultUrl: String {
        return baseUrl + path
    }
    
    
    var url: String {
        switch self {
        case .new:
            return defaultUrl
            
        case .search(let query, let page):
            if let page = page {
                return defaultUrl + "/\(query)/\(page)"
            } else {
                return defaultUrl + "/\(query)"
            }
            
        case .detailBook(let isbn):
            return defaultUrl + "/\(isbn)"
        }
    }
}
