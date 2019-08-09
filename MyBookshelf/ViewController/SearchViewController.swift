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

    // MARK: - Used to Save Data Property
    private var searchPage: Int = 1
    private var searchKeyword: String = ""
    private var data: SearchBooks?
    private var isLoading: Bool = false

    // MARK: - TextField Debounce Property
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

        searchPage = 1
        searchKeyword = keyword
        workItem = DispatchWorkItem { [weak self] in
            self?.setSearchBookData()
        }

        if let workItem = workItem {
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: workItem)
        }
    }

    // MARK: - Data Setting Method
    private func setSearchBookData() {
        if searchKeyword == "" {
            data = nil
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            DispatchQueue.main.async {
                self.view.endEditing(true)
            }

            itBookRequest().search(query: searchKeyword, page: searchPage, wait: {
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

    // MARk: - Data Load More Method
    private func loadMoreSearchBookData() {
        isLoading = true
        itBookRequest().search(query: searchKeyword, page: searchPage, wait: { }, finish: { }) { [weak self] result in
            self?.isLoading = false

            switch result {
            case .success(let data):
                self?.searchPage += 1
                
                self?.data?.error = data.error
                self?.data?.page = data.page
                self?.data?.books.append(contentsOf: data.books)
                
                self?.tableView.reloadData()
            case .failure(let error):
                ERROR_LOG(error.localizedDescription)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DetailBookViewController, let data = sender as? DetailBook {
            dest.setDetailBookData(data)
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let isbn = data?.books[safe: indexPath.row]?.isbn13 {
            itBookRequest().detail(isbn: isbn, wait: {
                self.indicatorView.isHidden = false
                self.indicatorView.startAnimating()
            }, finish: { [weak self] in
                self?.indicatorView.stopAnimating()
                self?.indicatorView.isHidden = true
            }) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.performSegue(withIdentifier: "showDetailBook", sender: data)

                case .failure(let error):
                    ERROR_LOG(error)
                }
            }
        }
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

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let data = data, let total = Int(data.total), let page = Int(data.page) {
            if (total - (page * 10)) > 0, indexPath.row == data.books.count - 5, !isLoading {
                DispatchQueue.main.async {
                    let spinner = UIActivityIndicatorView(style: .gray)
                    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                    spinner.startAnimating()
                    tableView.tableFooterView = spinner
                    tableView.tableFooterView?.isHidden = false
                }

                loadMoreSearchBookData()
            } else {
                let view = UIView()
                tableView.tableFooterView?.removeFromSuperview()
                view.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 5)
                tableView.tableFooterView = view
                tableView.tableFooterView?.isHidden = true
            }
        } else {
            let view = UIView()
            tableView.tableFooterView?.removeFromSuperview()
            view.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 5)
            tableView.tableFooterView = view
            tableView.tableFooterView?.isHidden = true
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
