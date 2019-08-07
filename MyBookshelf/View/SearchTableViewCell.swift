//
//  SearchTableViewCell.swift
//  MyBookshelf
//
//  Created by 장혜준 on 07/08/2019.
//  Copyright © 2019 장혜준. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    // MARK: - UI Property
    private let coverImageView: UIImageView = UIImageView().then {
        $0.backgroundColor = .lightGray
        $0.setCornerRadius(5)
    }
    private let titleLabel: UILabel = UILabel().then {
        $0.font = $0.font.withSize(18)
    }
    private let subTitleLabel: UILabel = UILabel().then {
        $0.font = $0.font.withSize(13)
        $0.textColor = .gray
        $0.numberOfLines = 2
    }
    private let isbnLabel: UILabel = UILabel().then {
        $0.font = $0.font.withSize(15)
    }
    private let priceLabel: UILabel = UILabel().then {
        $0.font = $0.font.withSize(15)
    }
    private let urlLabel: UILabel = UILabel().then {
        $0.font = $0.font.withSize(15)
    }
    
    // MARK: - Initialize
    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String? = NewTableViewCell.reuseIdentifierName) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        
        setViews()
        setViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews() {
        let views: [UIView] = [coverImageView, titleLabel, subTitleLabel, isbnLabel, priceLabel, urlLabel]
        addSubViews(views)
    }
    
    func setViewConstraints() {
        coverImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(10)
            make.size.equalTo(125)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalTo(coverImageView.snp.trailing).offset(10)
            make.trailingMargin.equalToSuperview().inset(15)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        isbnLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(subTitleLabel)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(isbnLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(isbnLabel)
        }
        
        urlLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(priceLabel)
        }
    }
}

extension SearchTableViewCell: Updatable {
    typealias T = Book
    
    func update(data: Book) {
        coverImageView.kf.setImage(with: URL(string: data.image))
        titleLabel.text = data.title
        subTitleLabel.text = data.subtitle
        isbnLabel.text = data.isbn13
        priceLabel.text = data.price
        urlLabel.text = data.url
    }
}
