//
//  AshtrayCoreDataModel.swift
//  AshtrayCoreData
//
//  Created by Leopold Lemmermann on 14.12.21.
//

import CoreData

typealias CountType = Count
typealias CountCollectionType = [CountType]
typealias CountCollectionIDType = Date
func getCountCollectionID(from date: Date) -> CountCollectionIDType {
    date.getComponents([.day, .month, .year]).getDate()
}

class AshtrayModel: ObservableObject {
    //starting date for statistics calculation
    @Published var startingID: Date {
        didSet {
            startingID = getCountCollectionID(from: startingID)
            UserDefaults.standard.set(startingID, forKey: "startingID")
        }
    }
    //counts object for quick access
    @Published var counts: CountCollectionType
    
    init(counts: CountCollectionType = CountCollectionType()) {
        self.startingID = UserDefaults.standard.object(forKey:"startingID") as? Date ?? Date()
        self.counts = counts
    }
}
