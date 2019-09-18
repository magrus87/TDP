//
//  PointPresentable.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 16/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class PointAnnotation: NSObject, MKAnnotation {
    var name: String?
    var workHours: String?
    var address: String?
    var picture: String?
    var coordinate: CLLocationCoordinate2D
    
    init(name: String?,
         coordinate: CLLocationCoordinate2D,
         workHours: String? = nil,
         address: String? = nil,
         picture: String? = nil) {
        self.name = name
        self.coordinate = coordinate
        self.workHours = workHours
        self.address = address
        self.picture = picture
        
        super.init()
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return nil
    }
}
