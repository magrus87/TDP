//
//  AppLocationManager.swift
//  CBOSAGO
//
//  Created by Alexander Makarov on 29/03/2018.
//  Copyright © 2018 65apps. All rights reserved.
//

import CoreLocation

protocol AppLocationManagerDelegate {
    func changedLocationPermission(coordinate: CLLocationCoordinate2D?, isAuthorized: Bool)
}

class AppLocationManager: NSObject {
    
    private let locationManager = CLLocationManager()
    
    var delegate: AppLocationManagerDelegate?
    
    override init() {
        super.init()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}

extension AppLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.changedLocationPermission(coordinate: manager.location?.coordinate,
                                            isAuthorized: (status == .authorizedWhenInUse || status == .authorizedAlways))
    }
}

