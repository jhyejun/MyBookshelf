//
//  NewViewController.swift
//  MyBookshelf
//
//  Created by 장혜준 on 29/07/2019.
//  Copyright © 2019 장혜준. All rights reserved.
//

import Foundation
import UIKit

class NewViewController: UIViewController {
    // MARK: - UI Property
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Data Property
    private var data: NewBooks?
    
    // MARK: - View LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NewTableViewCell.self, forCellReuseIdentifier: NewTableViewCell.reuseIdentifierName)
        
        itBookRequest().new { [weak self] result in
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
    
}

extension NewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.books.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: NewTableViewCell = tableView.dequeueReusableCell(withIdentifier: NewTableViewCell.reuseIdentifierName) as? NewTableViewCell else {
            preconditionFailure("NewTableViewCell is nil")
        }
        
        if let data = data?.books[safe: indexPath.row] {
            cell.update(data: data)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
