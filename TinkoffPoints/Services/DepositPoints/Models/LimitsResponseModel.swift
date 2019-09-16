//
//  LimitsResponseModel.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 15/09/2019.
//  Copyright © 2019 ru.magrus87. All rights reserved.
//

import Foundation

struct LimitsResponseModel: Decodable {
    let currency: CurrencyResponseModel
    let min: Int?
    let max: Int?
}
