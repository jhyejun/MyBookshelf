//
//  UIViewController+ext.swift
//  MyBookshelf
//
//  Created by 장혜준 on 31/07/2019.
//  Copyright © 2019 장혜준. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func push(viewController vc: UIViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(vc, animated: animated)
    }
}
