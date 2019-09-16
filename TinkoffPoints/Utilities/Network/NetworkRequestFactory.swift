//
//  NetworkRequestFactory.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 16/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import Foundation

protocol NetworkRequestFactory {
    func request(urlPath: String?,
                 method: HttpMethod,
                 headers: [String: String]?,
                 parameters: [String: Any]?) -> URLRequest?
}

final class NetworkRequestFactoryImpl {
    func request(urlPath: String?,
                 method: HttpMethod,
                 headers: [String: String]?,
                 parameters: [String: Any]? = nil) -> URLRequest? {
        
        guard let url = url(with: urlPath, method: method, parameters: parameters) else {
            return nil
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers?.forEach({
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        })
        
        if let parameters = parameters, method != .get {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters,
                                                           options: [])
        }
        return request
    }
    
    // MARK: - private
    
    private func url(with path: String?,
                     method: HttpMethod,
                     parameters: [String : Any]?) -> URL? {
        guard let path = path else {
            return nil
        }
        
        switch method {
        case .get:
            var urlComponents = URLComponents(string: path)
            urlComponents?.queryItems = parameters?
                .filter({ !$0.key.isEmpty })
                .compactMap({ (key, value) in
                    return URLQueryItem(name: key, value: "\(value)")
                })
            return urlComponents?.url
        case .post:
            return URL(string: path)
        }
    }
}
