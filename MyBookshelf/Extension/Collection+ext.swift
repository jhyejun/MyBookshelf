//
//  Collection+ext.swift
//  MyBookshelf
//
//  Created by 장혜준 on 31/07/2019.
//  Copyright © 2019 장혜준. All rights reserved.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
