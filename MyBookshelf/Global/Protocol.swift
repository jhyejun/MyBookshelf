//
//  Protocol.swift
//  MyBookshelf
//
//  Created by 장혜준 on 29/07/2019.
//  Copyright © 2019 장혜준. All rights reserved.
//

import Foundation

protocol Updatable {
    associatedtype T
    
    func update(data: T)
}

protocol PrepareLayout {
    
}
