//
//  CoreDataManager.swift
//  CoreDataMigration
//
//  Created by RamaKrishna on 27/11/21.
//

import Foundation
import CoreData

protocol CoreDataManager {
    func insert<T: NSManagedObject>(_ type: T.Type) -> T
    func fetchResults<T: NSManagedObject>(query: NSPredicate?,
                                          type: T.Type) -> [T]
    func fetchResults<T: NSManagedObject>(query: NSPredicate?,
                                          sortBasedOn: String?,
                                          type: T.Type) -> [T]
    func fetchResults<T: NSManagedObject>(query: NSPredicate?,
                                          properties: [String],
                                          sortBasedOn: String?,
                                          type: T.Type) -> [NSDictionary]
    func delete<T>(object: T) where T : NSManagedObject
    
    func fetchResultsCount<T: NSManagedObject>(query: NSPredicate?, type: T.Type) -> Int
    
    func resetChanges()
    func save()
}

final class CoreDataManagerImpl {
    
    //1
    static let shared = CoreDataManagerImpl()
    //2.
    private init() {} // Prevent clients from creating another instance.
    
    //3
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreDataMigration")
        
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

//MARK: - DataManager Impl
extension CoreDataManagerImpl: CoreDataManager {
    
    func insert<T: NSManagedObject>(_ type: T.Type) -> T {
        return T(context: persistentContainer.viewContext)
    }
    
    func fetchResults<T: NSManagedObject>(query: NSPredicate? = nil,
                                          type: T.Type) -> [T] {
        var results: [T] = []
        let entityName = String(describing: T.self)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = query
        do {
            results = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            results = []
        }
        return results
    }
    
    func fetchResultsCount<T: NSManagedObject>(query: NSPredicate? = nil,
                                               type: T.Type) -> Int {
        var results: Int = 0
        let entityName = String(describing: T.self)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.includesPendingChanges = true
        fetchRequest.predicate = query
        do {
            results = try persistentContainer.viewContext.count(for: fetchRequest)
        } catch {
            results = 0
        }
        return results
    }
    
    func fetchResults<T: NSManagedObject>(query: NSPredicate? = nil,
                                          sortBasedOn: String? = nil,
                                          type: T.Type) -> [T] {
        var results: [T] = []
        let entityName = String(describing: T.self)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.includesPendingChanges = true
        if let sortBasedOnProperty = sortBasedOn {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortBasedOnProperty, ascending: false)]
        }
        fetchRequest.predicate = query
        do {
            results = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            results = []
        }
        return results
    }
    
    func fetchResults<T: NSManagedObject>(query: NSPredicate?,
                                          properties: [String],
                                          sortBasedOn: String? = nil,
                                          type: T.Type) -> [NSDictionary] {
        var results = [NSDictionary]()
        let entityName = String(describing: T.self)
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: entityName)
        fetchRequest.propertiesToFetch = properties
        fetchRequest.predicate = query
        fetchRequest.includesPendingChanges = true
        
        if let sortBasedOnProperty = sortBasedOn {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortBasedOnProperty, ascending: false)]
        }
        
        fetchRequest.resultType = .dictionaryResultType
        do {
            results = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("fetchAllRecordsByColumn Error- \(error)")
        }
        return results
    }
    
    func delete<T: NSManagedObject>(object: T) {
        persistentContainer.viewContext.delete(object)
    }
    
    func resetChanges() {
        persistentContainer.viewContext.reset()
    }
    
    func save () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
