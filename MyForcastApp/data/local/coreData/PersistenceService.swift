//
//  PersistenceService.swift
//  MyForcastApp
//
//  Created by MacBook Air on 20/08/2022.
//

import Foundation
import CoreData

class PersistenceService {
    
    private init() { }
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "MyForcastApp")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
    static func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("SAVED")
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                // fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static func deleteEntityByName(name: String) {
        if let appEntity = NSEntityDescription.entity(forEntityName: name, in: context) {
            
            let entity = NSManagedObject(entity: appEntity, insertInto: context)
            context.delete(entity)
            do {
                try context.save()
                print("Entity \(name) Deleted successfully")
            } catch let error as NSError {
                print("Failed to delete appEntity! \(error): \(error.userInfo)")
            }
        }
    }
}
