//
//  MKMapView+Extension.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 16/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    func register<T: MKAnnotationView>(_: T.Type) {
        register(T.self, forAnnotationViewWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableView<T: MKAnnotationView>() -> T {
        guard let view = dequeueReusableAnnotationView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could not dequeue view with identifier: \(T.reuseIdentifier)")
        }
        return view
    }
    
    func dequeueReusableView<T: MKAnnotationView>(annotation: MKAnnotation) -> T {
        guard let view = dequeueReusableAnnotationView(withIdentifier: T.reuseIdentifier, for: annotation) as? T else {
            fatalError("Could not dequeue view with identifier: \(T.reuseIdentifier)")
        }
        return view
    }
}

extension MKMapView {
    func topLeftCoordinate() -> CLLocationCoordinate2D {
        return self.convert(CGPoint(x: 0.0, y: 0.0),
                            toCoordinateFrom: self)
    }
    
    func currentRadius() -> Double {
        let centerLocation = CLLocation(latitude: self.centerCoordinate.latitude,
                                        longitude: self.centerCoordinate.longitude)
        let topLeftCoordinate = self.topLeftCoordinate()
        let topLeftLocation = CLLocation(latitude: topLeftCoordinate.latitude,
                                         longitude: topLeftCoordinate.longitude)
        return centerLocation.distance(from: topLeftLocation)
    }
}
