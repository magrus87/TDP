//
//  Network.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 15/09/2019.
//  Copyright © 2019 ru.magrus87. All rights reserved.
//

import Foundation

protocol Network {
    func send(request: NetworkRequest, completion: @escaping (Data?, NetworkError?) -> Void)
}

final class NetworkUtility: Network {
    private lazy var requestFactory = NetworkRequestFactoryImpl()
    
    internal func send(request: NetworkRequest, completion: @escaping (Data?, NetworkError?) -> Void) {
        guard let request = requestFactory.request(urlPath: request.url,
                                                   method: request.method,
                                                   headers: request.headers,
                                                   parameters: request.parameters) else {
                                                    completion(nil, NetworkError.badRequest)
                                                    return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, NetworkError.undefined(description: error.localizedDescription))
                return
            }
            
            guard let responseData = data else {
                let error = NetworkError.emptyResponse
                completion(nil, error)
                return
            }
            
            completion(responseData, nil)
        }
        task.resume()
    }
}
