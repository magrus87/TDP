//
//  PointsRequest.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 16/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import Foundation

struct PointsRequest: NetworkRequest {
    let latitude: Double
    let longitude: Double
    let radius: Int
    let partners: String?
    
    var configName: String {
        return "DepositPoints.API"
    }
    
    var hostKey: String {
        return "DepositPoints.API.Host"
    }
    
    var versionKey: String {
        return "DepositPoints.API.Version"
    }
    
    var methodKey: String {
        return "DepositPoints.API.Points"
    }
    
    var parameters: [String : Any]? {
        var result: [String : Any] = ["latitude": latitude,
                                      "longitude": longitude,
                                      "radius": radius]
        if let partners = partners {
            result["partners"] = partners
        }
        return result
    }
}
