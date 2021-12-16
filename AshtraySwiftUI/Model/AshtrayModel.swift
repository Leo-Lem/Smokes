//
//  AshtrayCoreDataModel.swift
//  AshtrayCoreData
//
//  Created by Leopold Lemmermann on 14.12.21.
//

import Foundation
import MyOthers

typealias CountType = Count
typealias CountIDType = Date

struct Count: Codable, Hashable {
    let id: CountIDType
    var amount: Int
    
    static func getID(from date: Date) -> CountIDType {
        date.getComponents([.day, .month, .year]).getDate()
    }
}

class AshtrayModel {
    var startingID: CountIDType {
        get {
            UserDefaults.standard.object(forKey:"startingID") as? CountIDType ?? CountIDType()
        }
        set {
            UserDefaults.standard.set(Count.getID(from: newValue), forKey: "startingID")
        }
    }
    
    var counts: [CountType] {
        get {
            UserDefaults.standard.getObject(forKey: "counts", castTo: [CountType].self) ?? []
        }
        set {
            let modifiedNewValue = newValue.filter { $0.amount > 0 }
            UserDefaults.standard.setObject(modifiedNewValue, forKey: "counts")
        }
    }
}
