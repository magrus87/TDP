//
//  NetworkRequest.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 15/09/2019.
//  Copyright © 2019 ru.magrus87. All rights reserved.
//

import Foundation

protocol NetworkRequest {
    var method: HttpMethod { get }
    
    var headers: [String: String]? { get }
    
    var parameters: [String: Any]? { get }

    /// Имя файла настроек
    var configName: String { get }
    
    var hostKey: String { get }
    
    var versionKey: String { get }
    
    var methodKey: String { get }
    
    var absolutePath: String? { get }
}

extension NetworkRequest {
    var method: HttpMethod {
        return .get
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json; charset=utf-8"]
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var absolutePath: String? {
        guard let configPath = Bundle.main.path(forResource: self.configName, ofType: "plist") else {
            return nil
        }
        
        guard let config = NSDictionary(contentsOfFile: configPath) else {
            return nil
        }
        
        guard let host = config[hostKey] as? String else {
            return nil
        }
        
        guard let version = config[versionKey] as? String else {
            return nil
        }
        
        guard let method = config[methodKey] as? String else {
            return nil
        }
        
        return "\(host)/\(version)/\(method)"
    }
}
