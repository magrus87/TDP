//
//  PartnersResponseModel.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 15/09/2019.
//  Copyright © 2019 ru.magrus87. All rights reserved.
//

import Foundation

struct PartnersResponseModel: Decodable {
    let id: String
    let name: String
    let picture: String
    let url: String
    let hasLocations: Bool
    let isMomentary: Bool
    let depositionDuration: String
    let limitations: String
    let pointType: String
    let externalPartnerId: String
    let description: String
    let moneyMin: Int
    let moneyMax: Int
    let hasPreferentialDeposition: Bool
    let limits: [LimitsResponseModel]
    let dailyLimits: [DailyLimitsResponseModel]
}
