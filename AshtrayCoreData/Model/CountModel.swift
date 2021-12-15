//
//  CountModel.swift
//  AshtrayCoreData
//
//  Created by Leopold Lemmermann on 12.12.21.
//

import CoreData

class CountModel {
    var moc: NSManagedObjectContext
    private let countsFetch: NSFetchRequest = NSFetchRequest<Count>(entityName: "Count")
    var counts: [Count]
    
    init(context: NSManagedObjectContext) {
        self.moc = context
        self.counts = (try? moc.fetch(countsFetch)) ?? []
    }
    
    
}
