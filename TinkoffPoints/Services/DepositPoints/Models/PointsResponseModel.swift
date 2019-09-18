//
//  PointsResponseModel.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 15/09/2019.
//  Copyright © 2019 ru.magrus87. All rights reserved.
//

import Foundation

struct PointsResponseModel: Decodable {
    let externalId: String
    let partnerName: String?
    let latitude: Double
    let longitude: Double
    let workHours: String?
    let address: String?
    
    enum CodingKeys: CodingKey {
        case externalId
        case partnerName
        case location
        case workHours
        case fullAddress
    }
    
    enum LocationKeys: CodingKey {
        case latitude
        case longitude
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        externalId = try values.decode(String.self, forKey: .externalId)
        partnerName = try? values.decode(String.self, forKey: .partnerName)
        workHours = try? values.decode(String.self, forKey: .workHours)
        address = try? values.decode(String.self, forKey: .fullAddress)
        
        let location = try values.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        latitude = try location.decode(Double.self, forKey: .latitude)
        longitude = try location.decode(Double.self, forKey: .longitude)
    }
}
