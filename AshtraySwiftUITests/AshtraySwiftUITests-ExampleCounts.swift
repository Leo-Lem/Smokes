//
//  AshtraySwiftUITests-ExampleCounts.swift
//  AshtraySwiftUITests
//
//  Created by Leopold Lemmermann on 22.12.21.
//

import XCTest
import MyOthers
@testable import AshtraySwiftUI

extension AshtraySwiftUITests {
    struct Example: CustomStringConvertible {
        var counts: [CountType]
        let startID: CountIDType, interval: Int, amount: Int, endID: CountIDType
        
        init(startID: CountIDType, interval: Int, empty: Bool = false, amount: Int = 5) {
            self.startID = startID
            self.interval = interval
            self.endID = Count.getID(from: startID.getDateWithValueAdded(interval, for: .day))
            self.counts = [CountType]()
            self.amount = empty ? 0 : amount
            
            if !empty {
                for i in 0...interval {
                    let id = startID.getDateWithValueAdded(i, for: .day)
                    self.counts.append(Count(id: id, amount: amount))
                }
            }
        }
        
        static let standard = Example(startID: Count.getID(from: Date()), interval: 100, amount: 5)
        static let empty = Example(startID: Count.getID(from: Date()), interval: 100, empty: true)
        static let random = Example(startID: Count.getID(from: Date(timeIntervalSinceReferenceDate: Double.random(in: 0..<86400*365*20))),
                                    interval: Int.random(in: 61...364),
                                    amount: Int.random(in: 1...25))
        
        var description: String {
            """
            
            Example-Model:
                Start-ID \(self.startID),
                Interval \(self.interval),
                Amount \(self.amount),
                End-ID \(self.endID),
                Counts \(self.counts)
            
            """
        }
    }
}
