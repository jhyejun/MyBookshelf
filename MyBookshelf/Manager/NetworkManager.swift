//
//  NetworkManager.swift
//  MyBookshelf
//
//  Created by 장혜준 on 31/07/2019.
//  Copyright © 2019 장혜준. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkRequest {
    var url: String { get }
}

struct AFRequest {
    var url: String
    var method: HTTPMethod
    var parameters: Parameters?
    var encoding: ParameterEncoding
    var headers: HTTPHeaders?
    var interceptor: RequestInterceptor?
    
    init(request: NetworkRequest, method: HTTPMethod = .get) {
        self.url = request.url
        self.method = method
        self.parameters = nil
        self.encoding = URLEncoding.default
        self.headers = nil
        self.interceptor = nil
    }
    
    init(request: NetworkRequest, method: HTTPMethod, parameters: Parameters) {
        self.url = request.url
        self.method = method
        self.parameters = parameters
        self.encoding = URLEncoding.default
        self.headers = nil
        self.interceptor = nil
    }
    
    init(request: NetworkRequest, method: HTTPMethod, encoding: ParameterEncoding) {
        self.url = request.url
        self.method = method
        self.parameters = nil
        self.encoding = URLEncoding.default
        self.headers = nil
        self.interceptor = nil
    }
    
    init(request: NetworkRequest, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, interceptor: RequestInterceptor?) {
        self.url = request.url
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
        self.interceptor = interceptor
    }
}

class NetworkManager {
    fileprivate static let shared = NetworkManager()
    
    func request(_ request: AFRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        AF.request(request.url,
                   method: request.method,
                   parameters: request.parameters,
                   encoding: request.encoding,
                   headers: request.headers,
                   interceptor: request.interceptor)
            .responseData { (resp) in
                switch resp.result {
                case .success(let data):
                    completion(.success(data))
                    
                case .failure(let error):
                    ERROR_LOG(error)
                    completion(.failure(error))
                }
        }
    }
    
    func requestJSON(_ request: AFRequest, completion: @escaping (Result<Any, Error>) -> Void) {
        AF.request(request.url,
                   method: request.method,
                   parameters: request.parameters,
                   encoding: request.encoding,
                   headers: request.headers,
                   interceptor: request.interceptor)
            .responseJSON { (resp) in
                switch resp.result {
                case .success(let data):
                    DEBUG_LOG(data)
                    completion(.success(data))
                    
                case .failure(let error):
                    ERROR_LOG(error)
                    completion(.failure(error))
                }
        }
    }
}

func networkManager() -> NetworkManager {
    return NetworkManager.shared
}
