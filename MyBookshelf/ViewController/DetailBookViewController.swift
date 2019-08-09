//
//  DetailBookViewController.swift
//  MyBookshelf
//
//  Created by 장혜준 on 29/07/2019.
//  Copyright © 2019 장혜준. All rights reserved.
//

import UIKit

class DetailBookViewController: UIViewController {
    // MARK: - UI Property
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    // MARK: - Used to Save Data Property
    private var data: DetailBook?
    
    // MARK: - View LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchedUrlLabel(_:)))
        urlLabel.addGestureRecognizer(tapGesture)
        urlLabel.isUserInteractionEnabled = true
        
        coverImageView.setCornerRadius(5)
        
        if let data = data {
            titleLabel.text = data.title
            subTitleLabel.text = data.subtitle
            publisherLabel.text = data.publisher
            authorLabel.text = data.authors
            languageLabel.text = data.language
            yearLabel.text = data.year
            isbnLabel.text = data.isbn13
            priceLabel.text = data.price
            descLabel.text = data.desc
            urlLabel.text = data.url
            
            coverImageView.kf.setImage(with: URL(string: data.image))
        }
    }
    
    // MARK: - Event Method
    @objc func touchedUrlLabel(_ sender: UILabel) {
        if let urlString = data?.url, let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Data Setting Method
    func setDetailBookData(_ data: DetailBook) {
        self.data = data
    }
}
