//
//  CoreDataStack.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 07/07/23.
//

import CoreData

class CoreDataStack {
    private let container = NSPersistentContainer(name: "CurrencyConverter")
    
    static let shared = CoreDataStack()
    
    init(inMemory: Bool = false) {
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        loadPersistentStores()
    }
    
    private func loadPersistentStores() {
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func performBackgroundTask<T>(
        _ block: @escaping (NSManagedObjectContext) throws -> T
    ) async throws -> T {
        if #available(iOS 15.0, *) {
            return try await container.performBackgroundTask { managedObjectContext in
                return try block(managedObjectContext)
            }
        } else {
            return try await withCheckedThrowingContinuation { continuation in
                container.performBackgroundTask { managedObjectContext in
                    do {
                        let result = try block(managedObjectContext)
                        continuation.resume(returning: result)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    func save(managedObjectContext: NSManagedObjectContext? = nil) throws {
        let context = managedObjectContext ?? container.viewContext
        if !context.hasChanges { return }
    
        try context.save()
    }
}
