//
//  PersistentWorker.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 17/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import Foundation
import CoreData

protocol PersistentWorker {
    func savePartners(_ objects: [PartnerPresentable]?)
    
    func fetchPartners(with id: String?) -> [PartnerPresentable]?
    
    func savePoints(_ objects: [DepositPointPresentable]?)
    
    func fetchPoints(partners: [String]?) -> [DepositPointPresentable]?
}

final class PersistentWorkerImpl: PersistentWorker {
    func savePartners(_ objects: [PartnerPresentable]?) {
        guard let objects = objects else {
            return
        }
        
        let oldPartners = fetchPartners()?.subtract(objects)
        let newPartners = objects.subtract(fetchPartners())
        
        AppPersistentContainer.shared.container.performBackgroundTask { [weak self] (context) in
            oldPartners?.forEach {
                let object = self?.fetch(with: context,
                                         entityName: "Partner",
                                         predicate: NSPredicate(format: "id = %@", $0.id),
                                         fetchLimit: nil,
                                         sortDescriptors: nil).first
                
                object?.setValue($0.id, forKeyPath: "id")
                object?.setValue($0.name, forKeyPath: "name")
                object?.setValue($0.picture, forKeyPath: "picture")
            }
            
            newPartners?.forEach {
                let object = NSEntityDescription.insertNewObject(forEntityName: "Partner",
                                                                 into: context)
                
                object.setValue($0.id, forKeyPath: "id")
                object.setValue($0.name, forKeyPath: "name")
                object.setValue($0.picture, forKeyPath: "picture")
            }
            
            do {
                try context.save()
            } catch {
                fatalError("\(error.localizedDescription)")
            }
        }
        AppPersistentContainer.shared.saveContext()
    }
    
    func fetchPartners(with id: String? = nil) -> [PartnerPresentable]? {
        let context = AppPersistentContainer.shared.mainContext
        
        var predicate: NSPredicate?
        if let id = id {
            predicate = NSPredicate(format: "id == %@", id)
        }
        
        let results = fetch(with: context,
                            entityName: "Partner",
                            predicate: predicate,
                            fetchLimit: nil,
                            sortDescriptors: nil)
        
        return results.compactMap { obj in
            guard let id = obj.value(forKey: "id") as? String else {
                return nil
            }
            return PartnerPresentable(id: id,
                                      name: obj.value(forKey: "name") as? String,
                                      picture: obj.value(forKey: "picture") as? String)
        }
    }
    
    func savePoints(_ objects: [DepositPointPresentable]?) {
        guard let objects = objects else {
            return
        }
        
        let oldPoints = fetchPoints(partners: nil)?.subtract(objects)
        let newPoints = objects.subtract(fetchPoints(partners: nil))
        
        AppPersistentContainer.shared.container.performBackgroundTask { [weak self] (context) in
            oldPoints?.forEach {
                let object = self?.fetch(with: context,
                                         entityName: "DepositPoint",
                                         predicate: NSPredicate(format: "id = %@", $0.id),
                                         fetchLimit: nil,
                                         sortDescriptors: nil).first
                
                object?.setValue($0.id, forKeyPath: "id")
                object?.setValue($0.address, forKeyPath: "address")
                object?.setValue($0.latitude, forKeyPath: "latitude")
                object?.setValue($0.longitude, forKeyPath: "longitude")
                object?.setValue($0.partner?.id, forKeyPath: "partner_name")
                object?.setValue($0.workHours, forKeyPath: "work_hours")
            }
            
            newPoints?.forEach {
                let object = NSEntityDescription.insertNewObject(forEntityName: "DepositPoint",
                                                                 into: context)
                
                object.setValue($0.id, forKeyPath: "id")
                object.setValue($0.address, forKeyPath: "address")
                object.setValue($0.latitude, forKeyPath: "latitude")
                object.setValue($0.longitude, forKeyPath: "longitude")
                object.setValue($0.partner?.id, forKeyPath: "partner_name")
                object.setValue($0.workHours, forKeyPath: "work_hours")
            }
            
            do {
                try context.save()
            } catch {
                fatalError("\(error.localizedDescription)")
            }
        }
        AppPersistentContainer.shared.saveContext()
    }
    
    func fetchPoints(partners: [String]?) -> [DepositPointPresentable]? {
        let context = AppPersistentContainer.shared.mainContext
        
        var predicate: NSPredicate?
        if let partners = partners {
            predicate = NSPredicate(format: "partner_name IN %@", partners)
        }
        let results = fetch(with: context,
                            entityName: "DepositPoint",
                            predicate: predicate,
                            fetchLimit: nil,
                            sortDescriptors: nil)
        
        return results.compactMap { obj in
            guard let id = obj.value(forKey: "id") as? String,
                let latitude = obj.value(forKey: "latitude") as? Double,
                let longitude = obj.value(forKey: "longitude") as? Double else {
                return nil
            }
            let partner = fetchPartners(with: obj.value(forKey: "partner_name") as? String)?.first
            
            return DepositPointPresentable(id: id,
                                           workHours: obj.value(forKey: "work_hours") as? String,
                                           address: obj.value(forKey: "address") as? String,
                                           latitude: latitude,
                                           longitude: longitude,
                                           partner: partner)
        }
    }
}

extension PersistentWorkerImpl {
    private func fetch(with context: NSManagedObjectContext,
                       entityName: String,
                       predicate: NSPredicate?,
                       fetchLimit: Int?,
                       sortDescriptors: [NSSortDescriptor]?) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        if let fetchLimit = fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
        }
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        var results: [NSManagedObject] = []
        do {
            results = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
        return results
    }
    
    private func insertNewObject(with context: NSManagedObjectContext,
                                 entityName: String,
                                 updateBlock:((NSManagedObject) -> Void)?) -> NSManagedObject {
        let object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        updateBlock?(object)
        return object
    }
}
