//
//  CoreDataManager.swift
//  MovieApp
//
//  Created by Admin on 22/02/2022.
//

import Foundation
import CoreData

import CoreData

class CoreDataManager {
    
    
    static let shared = CoreDataManager()
    private init() { }
    
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieAppDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("something went wrog")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext { persistentContainer.viewContext }
    
    func saveContext() {
        if mainContext.hasChanges {
            do {
                try mainContext.save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
}
