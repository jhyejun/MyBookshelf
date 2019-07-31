//
//  NSObject+ext.swift
//  MyBookshelf
//
//  Created by 장혜준 on 31/07/2019.
//  Copyright © 2019 장혜준. All rights reserved.
//

import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
    
    class var reuseIdentifierName: String {
        return String(describing: self) + "Id"
    }
    
    var className: String {
        return type(of: self).className
    }
    
    var reuseIdentifierName: String {
        return type(of: self).reuseIdentifierName
    }
    
    var propertyNames: [String] {
        return Mirror(reflecting: self).children.compactMap { $0.label }
    }
    
    var propertyValues: [Any] {
        return Mirror(reflecting: self).children.compactMap { $0.value }
    }
}
