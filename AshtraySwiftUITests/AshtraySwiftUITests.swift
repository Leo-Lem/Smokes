//
//  AshtraySwiftUITests.swift
//  AshtraySwiftUITests
//
//  Created by Leopold Lemmermann on 16.12.21.
//

import XCTest
@testable import AshtraySwiftUI

class AshtraySwiftUITests: XCTestCase {
    private let startingID = Count.getID(from: Date(timeIntervalSince1970: 86400*365*50)) //20.12.2019
    private var testingID: CountIDType {
        Count.getID(from: startingID.addToValues([60], for: [.day])) //18.02.2020
    }
    private var exampleCounts: [CountType] {
        var counts = [CountType]()
        for i in 0..<100 {
            let id = startingID.addToValues([i], for: [.day])
            counts.append(Count(id: id, amount: 2))
        }
        return counts
    }
    private var exampleEmptyCounts = [CountType]()
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testExampleCountsContainsExamples() {
        XCTAssertFalse(exampleCounts.isEmpty)
    }
    
    func testSumCalculation() {
        let id = testingID //18.02.2020
        let counts = exampleCounts
        
        //day
        XCTAssertEqual(
            Int(counts.calculateSum(for: id, timespan: .day)),
            2
        )
        
        //week
        XCTAssertEqual(
            Int(counts.calculateSum(for: id, timespan: .week)),
            14
        )
        
        //month
        XCTAssertEqual(
            Int(counts.calculateSum(for: id, timespan: .month)),
            58
        )
        
        //alltime
        XCTAssertEqual(
            Int(counts.calculateSum(for: id, timespan: .alltime, from: startingID)),
            122
        )
    }
    
    func testSumCalculationWithEmptyArray() {
        let id = testingID //18.02.2020
        let counts = exampleEmptyCounts

        //day
        XCTAssertEqual(
            Int(counts.calculateSum(for: id, timespan: .day)),
            0
        )
        
        //week
        XCTAssertEqual(
            Int(counts.calculateSum(for: id, timespan: .week)),
            0
        )
        
        //month
        XCTAssertEqual(
            Int(counts.calculateSum(for: id, timespan: .month)),
            0
        )
        
        //alltime
        XCTAssertEqual(
            Int(counts.calculateSum(for: id, timespan: .alltime, from: startingID)),
            0
        )
    }
    
    func testAverageCalculation() {
        let id = testingID //18.02.2020
        let counts = exampleCounts
        
        //week-daily
        XCTAssertEqual(counts.calculateAverage(for: id, timespan: .week, interval: .daily),
                       2.0)
        //month-daily
        XCTAssertEqual(counts.calculateAverage(for: id, timespan: .month, interval: .daily),
                       2.0)
        //alltime-daily
        XCTAssertEqual(counts.calculateAverage(for: id, timespan: .alltime, interval: .daily, from: startingID),
                       2.0)
        
        //month-weekly
        XCTAssertEqual(counts.calculateAverage(for: id, timespan: .month, interval: .weekly),
                       11.6)
        //alltime-weekly
        XCTAssertEqual(counts.calculateAverage(for: id, timespan: .alltime, interval: .weekly, from: startingID),
                       13 + 5/9)
        
        //alltime-monthly
        XCTAssertEqual(counts.calculateAverage(for: id, timespan: .alltime, interval: .monthly, from: startingID),
                       40 + 2/3)
    }
    
    func testAverageCalculationWithEmptyArray() {
        let id = testingID //18.02.2020
        let counts = exampleEmptyCounts
        
        //week-daily
        XCTAssertEqual(counts.calculateAverage(for: id, timespan: .week, interval: .daily),
                       0)
        //month-daily
        XCTAssertEqual(counts.calculateAverage(for: id, timespan: .month, interval: .daily),
                       0)
        //alltime-daily
        XCTAssertEqual(counts.calculateAverage(for: id, timespan: .alltime, interval: .daily, from: startingID),
                       0)
        
        //month-weekly
        XCTAssertEqual(counts.calculateAverage(for: id, timespan: .month, interval: .weekly),
                       0)
        //alltime-weekly
        XCTAssertEqual(counts.calculateAverage(for: id, timespan: .alltime, interval: .weekly, from: startingID),
                       0)
        
        //alltime-monthly
        XCTAssertEqual(counts.calculateAverage(for: id, timespan: .alltime, interval: .monthly, from: startingID),
                       0)
    }
}
