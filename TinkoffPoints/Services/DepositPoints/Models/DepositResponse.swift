//
//  DepositResponse.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 15/09/2019.
//  Copyright © 2019 ru.magrus87. All rights reserved.
//

import Foundation

struct DepositResponse<T: Decodable>: Decodable {
    
    var resultCode: String
    
    var payload: T?
}
