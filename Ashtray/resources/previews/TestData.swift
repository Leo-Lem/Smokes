//
//  TestData.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import Foundation
import MyDates

struct TestData {
    //2021-01-01
    private static let date = Date(timeIntervalSinceReferenceDate: TimeInterval(20, unit: .year))
    
    static let entry = Entry(date, amount: 1)
    
    static var entries: [Entry] {
        var entries = [Entry]()
        for i in -50..<50 {
            entries.append(
                Entry(date + TimeInterval(i, unit: .day),
                      amount: i % 2 == 0 ? 5 : 10)
            )
        }
        return entries
    }
}
