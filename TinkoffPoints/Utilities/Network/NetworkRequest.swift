//
//  NetworkRequest.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 15/09/2019.
//  Copyright © 2019 ru.magrus87. All rights reserved.
//

import Foundation

protocol NetworkRequest {
    var url: String? { get set }
    
    var method: HttpMethod { get set }
    
    var headers: [String: String]? { get set }
    
    var parameters: [String: Any]? { get set }
}

struct NetworkRequestDefault: NetworkRequest {
    var url: String?
    
    var method: HttpMethod
    
    var headers: [String : String]?
    
    var parameters: [String : Any]?
}
