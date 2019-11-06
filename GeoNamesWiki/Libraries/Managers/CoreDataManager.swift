//
//  CoreDataManager.swift
//  GeoNamesWiki
//
//  Created by Sergey Krasiuk on 05/11/2019.
//  Copyright © 2019 Sergey Krasiuk. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
        
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Geonames")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        
        let context = self.persistentContainer.viewContext
        
        if context.hasChanges {
            
            do {
                try context.save()
                
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func isContextExists(by key: String) -> NSManagedObject? {
        
        let keyRequest = Keyword.request()
        keyRequest.predicate = NSPredicate(format: "key == %@", key)
        
        guard let keyword = try? CoreDataManager.shared.context.fetch(keyRequest).first else {
            return nil
        }
        
        return keyword
    }
}
