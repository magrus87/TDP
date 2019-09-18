//
//  DepositPointsUrlFactory.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 16/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import Foundation

public enum DepositPointsMethodsKey: String {
    case points = "DepositPoints.API.Points"
    case partners = "DepositPoints.API.Partners"
}

protocol DepositPointsUrlFactory {
    /// Имя файла настроек
    var configName: String { get }
    
    var hostKey: String { get }
    
    var versionKey: String { get }
    
    func urlPath(with methodKey: DepositPointsMethodsKey) -> String?
}

extension DepositPointsUrlFactory {
    var configName: String {
        return "DepositPoints.API"
    }
    
    var hostKey: String {
        return "DepositPoints.API.Host"
    }
    
    var versionKey: String {
        return "DepositPoints.API.Version"
    }
}

final class DepositPointsUrlFactoryImpl: DepositPointsUrlFactory {
    func urlPath(with methodKey: DepositPointsMethodsKey) -> String? {
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
        
        guard let method = config[methodKey.rawValue] as? String else {
            return nil
        }
        
        return "\(host)/\(version)/\(method)"
    }
}
