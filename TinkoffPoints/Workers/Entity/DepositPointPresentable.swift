//
//  DepositPointPresentable.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 18/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import Foundation

struct DepositPointPresentable {
    var id: String
    var workHours: String?
    var address: String?
    var latitude: Double
    var longitude: Double
    var partner: PartnerPresentable?
}

extension DepositPointPresentable: Equatable {
    static func == (lhs: DepositPointPresentable, rhs: DepositPointPresentable) -> Bool {
        return lhs.id == rhs.id && lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}


