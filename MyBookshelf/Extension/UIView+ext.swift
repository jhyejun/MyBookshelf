//
//  UIView+ext.swift
//  MyBookshelf
//
//  Created by 장혜준 on 31/07/2019.
//  Copyright © 2019 장혜준. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addSubViews(_ views: [UIView]) {
        views.forEach {
            self.addSubview($0)
        }
    }
    
    func setCornerRadius(_ radius: CGFloat, mask: CACornerMask? = nil) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        
        if let mask = mask, #available(iOS 11, *) {
            layer.maskedCorners = mask
        }
    }
    
    func defaultBorder() {
        setBorder(color: .black, width: 0.5)
    }
    
    func setBorder(color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
}
