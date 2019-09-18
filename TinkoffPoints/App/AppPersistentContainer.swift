//
//  AppPersistentContainer.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 16/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import Foundation
import CoreData

final class AppPersistentContainer {
    
    static var shared: AppPersistentContainer = AppPersistentContainer()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TinkoffPoints")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        let context = container.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = container.viewContext
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
}
