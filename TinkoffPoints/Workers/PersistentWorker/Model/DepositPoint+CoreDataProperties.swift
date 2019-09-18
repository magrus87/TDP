//
//  DepositPoint+CoreDataProperties.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 19/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//
//

import Foundation
import CoreData


extension DepositPoint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DepositPoint> {
        return NSFetchRequest<DepositPoint>(entityName: "DepositPoint")
    }

    @NSManaged public var partner_name: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var work_hours: String?
    @NSManaged public var address: String?
    @NSManaged public var id: String?
    @NSManaged public var partner: Partner?

}
