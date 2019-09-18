//
//  PointsWorker.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 17/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import Foundation
import CoreLocation

protocol PointsWorker {
    func points(latitude: Double,
                longitude: Double,
                radius: Int,
                success: (([PointAnnotation]) -> Void)?,
                failure: ((Error) -> Void)?)
}

final class PointsWorkerImpl: PointsWorker {
    private let pointsService: DepositPointsAPIService
    private let persistent: PersistentWorker
    
    init(pointsService: DepositPointsAPIService,
         persistent: PersistentWorker) {
        self.pointsService = pointsService
        self.persistent = persistent
    }
    
    func points(latitude: Double,
                longitude: Double,
                radius: Int,
                success: (([PointAnnotation]) -> Void)?,
                failure: ((Error) -> Void)?) {
        let accountType = "Credit"
        
        partners(accountType: accountType) { partners in
            partners?.forEach({ [weak self] partner in
                
                let completeBlock: (([PointsResponseModel]?) -> [PointAnnotation]) = { [partner] points in
                    return points?.compactMap({
                        PointAnnotation(name: partner.name,
                                         coordinate: CLLocationCoordinate2DMake($0.latitude,
                                                                                $0.longitude),
                                         workHours: $0.workHours,
                                         address: $0.address,
                                         picture: partner.picture)
                    }) ?? []
                }
                
                self?.points(
                    latitude: latitude,
                    longitude: longitude,
                    radius: radius,
                    partner: partner.id) { success?(completeBlock($0)) }
            })
        }
    }
}

extension PointsWorkerImpl {
    private func partners(accountType: String, complete: (([PartnersResponseModel]?) -> Void)?) {
        
        
        
        pointsService.fetchPartners(
            accountType: accountType,
            success: { partners in
                complete?(partners)
        }) { (error) in
            print(error.localizedDescription)
            complete?(nil)
        }
    }
    
    private func points(latitude: Double,
                        longitude: Double,
                        radius: Int,
                        partner: String,
                        complete: (([PointsResponseModel]?) -> Void)?) {
        pointsService.fetchPoints(
            latitude: latitude,
            longitude: longitude,
            radius: radius,
            partners: partner,
            success: { (points) in
                complete?(points)
        }) { (error) in
            print(error.localizedDescription)
            complete?(nil)
        }
    }
}
