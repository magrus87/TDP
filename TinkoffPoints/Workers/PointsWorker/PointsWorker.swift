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
    func fetchPoints(latitude: Double,
                     longitude: Double,
                     radius: Int,
                     success: (([DepositPointPresentable]?) -> Void)?,
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
    
    func fetchPoints(latitude: Double,
                     longitude: Double,
                     radius: Int,
                     success: (([DepositPointPresentable]?) -> Void)?,
                     failure: ((Error) -> Void)?) {
        let completePointsBlock: (([PartnerPresentable], [PointsResponseModel]?) -> Void) = { [weak self] (partnerPresentable, points) in
            
            guard let points = points, points.count > 0 else {
                success?(self?.persistent.fetchPoints(partners: partnerPresentable.map { $0.id }))
                return
            }
            
            let pointsPresentable = points.map({ point -> DepositPointPresentable in
                let partner = partnerPresentable.filter { $0.id == point.partnerName }.first
                
                return DepositPointPresentable(id: point.externalId,
                                               workHours: point.workHours,
                                               address: point.address,
                                               latitude: point.latitude,
                                               longitude: point.longitude,
                                               partner: partner)
            })
            self?.persistent.savePoints(pointsPresentable)
            success?(pointsPresentable)
        }
        
        let completePartnersBlock: (([PartnerPresentable]?) -> Void) = { [weak self] partners in
            guard let partners = partners, partners.count > 0 else {
                success?(nil)
                return
            }

            self?.points(latitude: latitude,
                         longitude: longitude,
                         radius: radius,
                         partners: partners.map { $0.id },
                         complete: { (points) in
                            completePointsBlock(partners, points)
            })
        }
        
        let accountType = "Credit"
        partners(accountType: accountType) { [weak self] partners in
            guard let partners = partners, partners.count > 0 else {
                completePartnersBlock(self?.persistent.fetchPartners(with: nil))
                return
            }
            
            let partnersPresentable = partners.map({
                PartnerPresentable(id: $0.id,
                                   name: $0.name,
                                   picture: $0.picture)
            })
            self?.persistent.savePartners(partnersPresentable)
            completePartnersBlock(partnersPresentable)
        }
    }
}

extension PointsWorkerImpl {
    private func partners(accountType: String, complete: (([PartnersResponseModel]?) -> Void)?) {
        pointsService.fetchPartners(
            accountType: accountType,
            success: { complete?($0) }) { (error) in
                print(error.localizedDescription)
                complete?(nil)
        }
    }
    
    private func points(latitude: Double,
                        longitude: Double,
                        radius: Int,
                        partners: [String]?,
                        complete: (([PointsResponseModel]?) -> Void)?) {
        pointsService.fetchPoints(
            latitude: latitude,
            longitude: longitude,
            radius: radius,
            partners: partners,
            success: { complete?($0) }) { (error) in
                print(error.localizedDescription)
                complete?(nil)
        }
    }
}
