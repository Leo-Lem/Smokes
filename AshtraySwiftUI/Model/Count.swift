//
//  Count.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 22.12.21.
//

import Foundation

typealias CountType = Count
typealias CountIDType = Date

struct Count: Codable, Hashable {
    let id: CountIDType
    var amount: Int
    
    static func getID(from date: Date) -> CountIDType {
        date.getComponents([.day, .month, .year]).getDate()
    }
}

extension Count: Comparable {
    static func <(lhs: Count, rhs: Count) -> Bool {
        lhs.id < rhs.id
    }
}
