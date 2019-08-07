//
//  SearchViewController.swift
//  MyBookshelf
//
//  Created by 장혜준 on 29/07/2019.
//  Copyright © 2019 장혜준. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - UI Property
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var searchTextField: UITextField!
    
    // MARK: - Data Property
    private var data: SearchBooks?
    
    private var workItem: DispatchWorkItem?
    
    // MARK: - View LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorView.isHidden = true
        searchTextField.setLeftPadding(10)
        
        tableView.separatorInset = .zero
        tableView.register(UINib(nibName: EmptyTableViewCell.className, bundle: nil), forCellReuseIdentifier: EmptyTableViewCell.reuseIdentifierName)
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifierName)
    }
    
    // MARK: - Event Method
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        guard let keyword = sender.text else { return }
        
        workItem?.cancel()
        
        workItem = DispatchWorkItem { [weak self] in
            self?.setSearchBookData(keyword: keyword)
        }
        
        if let workItem = workItem {
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: workItem)
        }
    }
    
    // MARK: - Data Setting Method
    private func setSearchBookData(keyword: String) {
        if keyword == "" {
            data = nil
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            return
        }
        
        itBookRequest().search(query: keyword, page: 1, wait: {
            DispatchQueue.main.async {
                self.indicatorView.isHidden = false
                self.indicatorView.startAnimating()
            }
        }, finish: { [weak self] in
            DispatchQueue.main.async {
                self?.indicatorView.stopAnimating()
                self?.indicatorView.isHidden = true
            }
        }) { [weak self] result in
            switch result {
            case .success(let data):
                self?.data = data
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                ERROR_LOG(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldDidChange(textField)
        return true
    }
}

extension SearchViewController: UITableViewDelegate {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = data?.books.count, count > 0 {
            return count
        } else if searchTextField.text?.isEmpty == false {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = data?.books[safe: indexPath.row] {
            guard let cell: SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifierName) as? SearchTableViewCell else {
                preconditionFailure("SearchTableViewCell is nil")
            }
            cell.update(data: data)
            
            return cell
        } else {
            guard let cell: EmptyTableViewCell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reuseIdentifierName) as? EmptyTableViewCell else {
                preconditionFailure("EmptyTableViewCell is nil")
            }
            cell.updateInfo(text: "No results were found for your search.")
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
