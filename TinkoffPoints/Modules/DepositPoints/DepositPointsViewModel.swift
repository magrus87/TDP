//
//  DepositPointsViewModel.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 16/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import Foundation
import CoreLocation

protocol DepositPointsViewModel {
    var defaultRadius: Int { get }
    
    func getPoints(latitude: Double,
                   longitude: Double,
                   radius: Int)
}

protocol DepositPointsViewModelOutput: class {
    func didReceivePoints(points: [PointAnnotation])
    
    func didInactivePoints(points: [PointAnnotation])
    
    func didReceiveError()
    
    func didReceiveUnavailableRadius()
}

final class DepositPointsViewModelImpl: DepositPointsViewModel {
    weak var delegate: DepositPointsViewModelOutput?
    
    private let maxRadius = 10000
    
    private var previousPoints: [PointAnnotation] = []
    private let semaphore = DispatchSemaphore(value: 1)
    
    private let worker: PointsWorker
    private let imageService: ImageService
    
    init(worker: PointsWorker,
         imageService: ImageService) {
        self.worker = worker
        self.imageService = imageService
    }
    
    // MARK: - DepositPointsViewModel
    
    var defaultRadius: Int {
        return 1000
    }
    
    func getPoints(latitude: Double,
                   longitude: Double,
                   radius: Int) {
        
        guard radius < maxRadius else {
            previousPoints.removeAll()
            self.delegate?.didReceiveUnavailableRadius()
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.worker.points(
                latitude: latitude,
                longitude: longitude,
                radius: radius,
                success: { [weak self] (points) in
                    guard points.count > 0 else {
                        return
                    }
                    
                    self?.semaphore.wait()
                    
                    let newPoints = points.subtract(self?.previousPoints)
                    let unavailablePoints = self?.previousPoints.filter {
                        let centerLocation = CLLocation(latitude: latitude,
                                                        longitude: longitude)
                        
                        let pointLocation = CLLocation(latitude: $0.coordinate.latitude,
                                                       longitude: $0.coordinate.longitude)
                        
                        return Int(centerLocation.distance(from: pointLocation)) > radius
                    }
                    
                    if let oldPoints = self?.previousPoints.subtract(unavailablePoints),
                        let newPoints = newPoints {
                        self?.previousPoints = oldPoints + newPoints
                    }
                    
                    self?.semaphore.signal()
                    
                    DispatchQueue.main.async {
                        if let newPoints = newPoints, newPoints.count > 0 {
                            self?.delegate?.didReceivePoints(points: newPoints)
                        }
                        
                        if let unavailablePoints = unavailablePoints, unavailablePoints.count > 0 {
                            self?.delegate?.didInactivePoints(points: unavailablePoints)
                        }
                    }
            }) { (_) in
                self?.delegate?.didReceiveError()
            }
        }
    }
}
