//
//  PartnerPresentable.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 18/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import Foundation

struct PartnerPresentable {
    var id: String
    var name: String?
    var picture: String?
}

extension PartnerPresentable: Equatable {
    static func == (lhs: PartnerPresentable, rhs: PartnerPresentable) -> Bool {
        return lhs.id == rhs.id
    }
}
