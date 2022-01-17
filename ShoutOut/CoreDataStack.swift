//
//  CoreDataStack.swift
//  ShoutOut
//
//  Created by Simon Peter Ojok on 10/01/2022.
//  Copyright © 2022 pluralsight. All rights reserved.
//

import Foundation
import CoreData

func createMainContext() -> NSManagedObjectContext {
    let modelURL = Bundle.main.url(forResource: "ShoutOut", withExtension: "momd")
    guard let model = NSManagedObjectModel(contentsOf: modelURL!) else { fatalError("modal not found")}
    
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    let storeURL = URL.documentURL
        .appendingPathComponent("ShoutOut-v2.sqlite")
    
    try! psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
    
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    context.persistentStoreCoordinator = psc
    return context
}

extension URL {
    static var documentURL: URL {
        return try! FileManager
            .default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
}

protocol ManagedObjectContextDependentType {
    var managedObjectContext: NSManagedObjectContext! {get set}
}
