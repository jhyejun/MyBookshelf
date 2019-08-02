//
//  EmptyTableViewCell.swift
//  MyBookshelf
//
//  Created by 장혜준 on 02/08/2019.
//  Copyright © 2019 장혜준. All rights reserved.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {
    @IBOutlet weak private var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateInfo(text: String) {
        infoLabel.text = text
    }
}
