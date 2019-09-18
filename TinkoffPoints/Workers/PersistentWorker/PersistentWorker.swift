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
    func save(_ objects: [NSManagedObject]?)
    
    func fetch() -> [NSManagedObject]?
}

final class PersistentWorkerImpl: PersistentWorker {
    private func fetch(entityName: String,
                       sortKey: String? = nil,
                       context: NSManagedObjectContext) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        if let sortKey = sortKey {
            let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        
        var results: [NSManagedObject] = []
        do {
            results = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
        return results
    }
    
    // MARK: - PersistentWorker
    
    func save(_ objects: [NSManagedObject]?) {
        guard let objects = objects else {
            return
        }
        
        
        let context = AppPersistentContainer.shared.mainContext
        
//        objects.forEach {
//            let object = NSEntityDescription.insertNewObject(forEntityName: "News", into: context)
//
//            object.setValue($0.id, forKeyPath: "id")
//            object.setValue($0.text, forKeyPath: "text")
//            object.setValue($0.publicationDate, forKeyPath: "publicationDate")
//        }
        
        AppPersistentContainer.shared.saveContext()
    }
    
    func fetch() -> [NSManagedObject]? {
        let context = AppPersistentContainer.shared.mainContext
//        let results = fetch(entityName: "News", sortKey: "publicationDate", context: context)

        return nil
//        return results.map { obj -> TinkoffNews? in
//            guard let id = obj.value(forKey: "id") as? Int,
//                let text = obj.value(forKey: "text") as? String,
//                let publicationDate = obj.value(forKey: "publicationDate") as? Date else {
//                    return nil
//            }
//            return TinkoffNews(id: id, text: text, publicationDate: publicationDate)
//            }.filter({
//                $0 != nil
//            }) as? [TinkoffNews]
    }
    
//    - (__kindof NSManagedObject *)insertNewObjectWithContext:(NSManagedObjectContext *)context
//    entityName:(NSString *)entityName
//    updateBlock:(void (^)(__kindof NSManagedObject *obj))updateBlock
//    {
//    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName
//    inManagedObjectContext:context];
//
//    //Здесь доабвил проверку тк при создании милза updateBlock = NULL и крашит
//    if (updateBlock) {
//    updateBlock(object);
//    }
//
//    return object;
//    }
//
//    - (NSArray *)fetchObjectsWithContext:(NSManagedObjectContext *)context
//    entityName:(NSString *)entityName
//    predicate:(NSPredicate *)predicate
//    sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors
//    fetchLimit:(NSNumber *)fetchLimit
//    isReturnsObjectsAsFaults:(BOOL)isReturnsObjectsAsFaults
//    {
//    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName
//    inManagedObjectContext:context];
//    [fetch setEntity:entityDescription];
//    if (fetchLimit) {
//    [fetch setFetchLimit:fetchLimit.unsignedIntegerValue];
//    }
//    if (predicate) {
//    [fetch setPredicate:predicate];
//    }
//    if (sortDescriptors) {
//    [fetch setSortDescriptors:sortDescriptors];
//    }
//    [fetch setReturnsObjectsAsFaults:isReturnsObjectsAsFaults];
//
//    NSError *error = nil;
//    NSArray *result = [context executeFetchRequest:fetch error:&error];
//    return result ?: @[];
//    }
}
