//
//  NewTableViewCell.swift
//  MyBookshelf
//
//  Created by 장혜준 on 29/07/2019.
//  Copyright © 2019 장혜준. All rights reserved.
//

import Foundation
import UIKit
import Then

class NewTableViewCell: UITableViewCell {
    // MARK: - UI Property
    private let coverImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "s")
    }
    private let titleLabel: UILabel = UILabel().then {
        $0.text = "Title : "
    }
    private let subTitleLabel: UILabel = UILabel().then {
        $0.text = "Subtitle : "
    }
    private let isbnLabel: UILabel = UILabel().then {
        $0.text = "International Standard Book Number : "
    }
    private let priceLabel: UILabel = UILabel().then {
        $0.text = "Price : "
    }
    private let urlButton: UIButton = UIButton().then {
        $0.setTitle("URL : ", for: .normal)
    }
    
    // MARK: - Initialize
    init() {
        super.init(style: .default, reuseIdentifier: "NewTableViewCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewTableViewCell: Updatable {
    typealias T = Book
    
    func update(data: Book) {
        self.coverImageView.image = UIImage(named: data.image)
        self.titleLabel.text = data.title
        self.subTitleLabel.text = data.subtitle
        self.isbnLabel.text = data.isbn13
        self.priceLabel.text = data.price
        self.urlButton.setTitle(data.url, for: .normal)
    }
}
