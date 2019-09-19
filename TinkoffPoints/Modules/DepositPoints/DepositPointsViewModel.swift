//
//  DepositPointsViewModel.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 16/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol DepositPointsViewModel {
    var defaultRadius: Int { get }
    
    func getPoints(latitude: Double,
                   longitude: Double,
                   radius: Int)
    
    func getImage(by name: String?, complete:((UIImage?) -> Void)?)
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
            self?.worker.fetchPoints(
                latitude: latitude,
                longitude: longitude,
                radius: radius,
                success: { [weak self] (points) in
                    guard let points = points, points.count > 0 else {
                        return
                    }
                    
                    let annotations = points.map({
                        PointAnnotation(id: $0.id,
                                        name: $0.partner?.name,
                                        coordinate: CLLocationCoordinate2DMake($0.latitude,
                                                                               $0.longitude),
                                        workHours: $0.workHours,
                                        address: $0.address,
                                        picture: $0.partner?.picture)
                    })
                    
                    self?.semaphore.wait()
                    
                    // пробегаем по вновь полученным точкам:
                    // удаляем те которые на экран уже не попадают,
                    // оставляем старые, чтоб не перерисовывать
                    // и добавляем новые
                    let newPoints = self?.newAnnotaions(of: annotations)
                    let unavailablePoints = self?.unavailableAnnotaions(latitude: latitude, longitude: longitude, radius: radius)
                    let oldPoints = self?.oldAnnotaions(without: unavailablePoints)
                    if let oldPoints = oldPoints, let newPoints = newPoints {
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
    
    func getImage(by name: String?, complete:((UIImage?) -> Void)?) {
        guard let name = name else {
            complete?(nil)
            return
        }
        
        // я знаю, что этот урл надо куда то засунуть, но уже сил нет :((
        let imageUrl = "https://static.tinkoff.ru/icons/deposition-partners-v3/xhdpi/" + name
        imageService.image(url: imageUrl) { (image) in
            DispatchQueue.main.async {
                complete?(image)
            }
        }
    }
}

extension DepositPointsViewModelImpl {

    private func newAnnotaions(of annotations: [PointAnnotation]) -> [PointAnnotation] {
        return annotations
            .filter({
                return !previousPoints.map({ $0.id }).contains($0.id)
            })
    }
    
    private func unavailableAnnotaions(latitude: Double,
                                       longitude: Double,
                                       radius: Int) -> [PointAnnotation] {
        return previousPoints.filter {
            let centerLocation = CLLocation(latitude: latitude,
                                            longitude: longitude)
            
            let pointLocation = CLLocation(latitude: $0.coordinate.latitude,
                                           longitude: $0.coordinate.longitude)
            
            return Int(centerLocation.distance(from: pointLocation)) > radius
        }
    }
    
    private func oldAnnotaions(without annotations: [PointAnnotation]?) -> [PointAnnotation] {
        guard let unavailablePoints = annotations else {
            return []
        }
        return previousPoints
            .filter({
                return !unavailablePoints.map({ $0.id }).contains($0.id)
            })
    }
}
