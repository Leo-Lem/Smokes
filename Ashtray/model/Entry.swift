//
//  Entry.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import Foundation
import MyDates
import CloudKit

struct Entry: Codable, Identifiable {
    let id: Date
    var amount: Int {
        didSet { if amount < 0 { amount = 0 } }
    }
    
    init(_ date: Date, amount: Int = 0) {
        self.id = date.startOfDay()!
        self.amount = amount
    }
}
