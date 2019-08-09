//
//  ITBookRequest.swift
//  MyBookshelf
//
//  Created by 장혜준 on 31/07/2019.
//  Copyright © 2019 장혜준. All rights reserved.
//

import Foundation

class ITBookRequest {
    fileprivate static let shared: ITBookRequest = ITBookRequest()
    
    private init() { }
    
    func new(wait: () -> Void, finish: @escaping () -> Void, completion: @escaping (Result<NewBooks, Error>) -> Void) {
        let request: AFRequest = AFRequest(request: ITBook.new, method: .get)
        
        wait()
        networkManager().request(request) { result in
            finish()
            switch result {
            case .success(let data):
                do {
                    let respData: NewBooks = try NewBooks(data: data)
                    completion(.success(respData))
                } catch {
                    ERROR_LOG(error.localizedDescription)
                    completion(.failure(error))
                }
                
            case .failure(let error):
                ERROR_LOG(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func search(query: String, page: Int, wait: () -> Void, finish: @escaping () -> Void, completion: @escaping (Result<SearchBooks, Error>) -> Void) {
        let request: AFRequest = AFRequest(request: ITBook.search(query: query, page: String(page)), method: .get)
        
        wait()
        networkManager().request(request) { result in
            finish()
            switch result {
            case .success(let data):
                do {
                    let respData: SearchBooks = try SearchBooks(data: data)
                    completion(.success(respData))
                } catch {
                    ERROR_LOG(error.localizedDescription)
                    completion(.failure(error))
                }
                
            case .failure(let error):
                ERROR_LOG(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func detail(isbn: String, wait: () -> Void, finish: @escaping () -> Void, completion: @escaping (Result<DetailBook, Error>) -> Void) {
        let request: AFRequest = AFRequest(request: ITBook.detailBook(isbn: isbn), method: .get)
        
        wait()
        networkManager().request(request) { result in
            finish()
            switch result {
            case .success(let data):
                do {
                    let respData: DetailBook = try DetailBook(data: data)
                    completion(.success(respData))
                } catch {
                    ERROR_LOG(error.localizedDescription)
                    completion(.failure(error))
                }
                
            case .failure(let error):
                ERROR_LOG(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}

func itBookRequest() -> ITBookRequest {
    return ITBookRequest.shared
}
