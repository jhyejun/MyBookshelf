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
}

func itBookRequest() -> ITBookRequest {
    return ITBookRequest.shared
}