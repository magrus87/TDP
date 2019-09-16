//
//  PartnersRequest.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 16/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import Foundation

struct PartnersRequest: NetworkRequest {
    let accountType: String
    
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
        return "DepositPoints.API.Partners"
    }
    
    var parameters: [String : Any]? {
        return ["accountType": accountType]
    }
}
