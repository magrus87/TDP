//
//  Partner+CoreDataProperties.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 19/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//
//

import Foundation
import CoreData


extension Partner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Partner> {
        return NSFetchRequest<Partner>(entityName: "Partner")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var picture: String?
    @NSManaged public var points: DepositPoint?

}
