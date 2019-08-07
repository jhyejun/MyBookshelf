//
//  NewViewController.swift
//  MyBookshelf
//
//  Created by 장혜준 on 29/07/2019.
//  Copyright © 2019 장혜준. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {
    // MARK: - UI Property
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    // MARK: - Data Property
    private var data: NewBooks?
    
    // MARK: - View LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorView.isHidden = true
        
        tableView.separatorInset = .zero
        tableView.register(UINib(nibName: EmptyTableViewCell.className, bundle: nil), forCellReuseIdentifier: EmptyTableViewCell.reuseIdentifierName)
        tableView.register(NewTableViewCell.self, forCellReuseIdentifier: NewTableViewCell.reuseIdentifierName)
        
        setNewBookData()
    }
    
    // MARK: - Set TableView Data
    private func setNewBookData() {
        itBookRequest().new(wait: {
            self.indicatorView.isHidden = false
            self.indicatorView.startAnimating()
        }, finish: { [weak self] in
            self?.indicatorView.stopAnimating()
            self?.indicatorView.isHidden = true
        }) { [weak self] result in
            switch result {
            case .success(let data):
                self?.data = data
                self?.tableView.reloadData()
                
            case .failure(let error):
                ERROR_LOG(error)
            }
        }
    }
}

extension NewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let books = data?.books, !books.isEmpty {
            return UITableView.automaticDimension
        } else {
            return tableView.frame.height
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let books = data?.books, !books.isEmpty {
            return 200
        } else {
            return tableView.frame.height
        }
    }
}

extension NewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = data?.books.count, count > 0 {
            return count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = data?.books[safe: indexPath.row] {
            guard let cell: NewTableViewCell = tableView.dequeueReusableCell(withIdentifier: NewTableViewCell.reuseIdentifierName) as? NewTableViewCell else {
                preconditionFailure("NewTableViewCell is nil")
            }
            cell.update(data: data)
            
            return cell
        } else {
            guard let cell: EmptyTableViewCell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reuseIdentifierName) as? EmptyTableViewCell else {
                preconditionFailure("EmptyTableViewCell is nil")
            }
            cell.updateInfo(text: "No new books.")
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
