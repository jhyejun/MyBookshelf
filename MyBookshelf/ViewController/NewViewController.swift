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
    
    // MARK: - View LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension NewViewController: UITableViewDelegate {
    
}

extension NewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: NewTableViewCell = NewTableViewCell() else {
            preconditionFailure("NewTableViewCell is nil")
        }
        
        return cell
    }
}
