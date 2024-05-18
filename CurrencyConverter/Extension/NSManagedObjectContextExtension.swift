//
//  NSManagedObjectContextExtension.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 18/05/24.
//

import CoreData

extension NSManagedObjectContext {
    func saveIfNecessary() throws {
        if !hasChanges { return }
        
        try save()
    }
}
