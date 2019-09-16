//
//  CurrencyResponseModel.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 15/09/2019.
//  Copyright © 2019 ru.magrus87. All rights reserved.
//

import Foundation

struct CurrencyResponseModel: Decodable {
    let code: Int
    let name: String
    let strCode: String
}
