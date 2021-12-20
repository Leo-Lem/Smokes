//
//  AshtraySwiftUITests.swift
//  AshtraySwiftUITests
//
//  Created by Leopold Lemmermann on 16.12.21.
//

import XCTest
import MyOthers
@testable import AshtraySwiftUI

class AshtraySwiftUITests: XCTestCase {
    //MARK: configuration
    private var exampleDays = 0, startID = CountIDType(), endID = CountIDType(), testingInterval = 0, testingAmount = 0, testingID = CountIDType()
    private var exampleCounts = [CountType]()
    private var testWithEmptyCountsArray = false
    
    override func setUpWithError() throws {
        exampleDays = Int.random(in: 61...364)
        startID = Count.getID(from: Date(timeIntervalSinceReferenceDate: Double.random(in: 0..<86400*365*20)))
        endID = Count.getID(from: startID.getDateWithValueAdded(exampleDays, for: .day))
        testingInterval = Int.random(in: 30..<(exampleDays-31))
        testingID = Count.getID(from: startID.getDateWithValueAdded(testingInterval, for: .day))
        testingAmount = Int.random(in: 1...25)
        
        
        
        if !testWithEmptyCountsArray {
            for i in 0...exampleDays {
                let id = startID.getDateWithValueAdded(i, for: .day)
                exampleCounts.append(Count(id: id, amount: testingAmount))
            }
        }
    }

    override func tearDownWithError() throws {
        print("""
            \nTested with:
                Starting-ID: \(startID),
                End-ID: \(endID),
                Example-Days: \(exampleDays),
                Testing-ID: \(testingID),
                Testing-Interval: \(testingInterval),
                Testing-Amount: \(testingAmount)\n
            """)
    }
    
    func testSumCalculation() {
        let interval = testingInterval + 1, amount = testingAmount, id = testingID, counts = exampleCounts
        
        //day
        XCTAssertEqual(Int(counts.calculateSum(for: id, timespan: .day)), amount)
        
        //week
        XCTAssertEqual(Int(counts.calculateSum(for: id, timespan: .week)), amount * 7)
        
        //month
        XCTAssertEqual(Int(counts.calculateSum(for: id, timespan: .month)),
                       amount * testingID.asDateComponents.daysInMonth, accuracy: amount * 2)
        
        //alltime
        XCTAssertEqual(Int(counts.calculateSum(for: id, timespan: .alltime, from: startID)), amount * interval, accuracy: amount * 2)
    }
    
    func testAverageCalculation() {
        let id = testingID, amount = Double(testingAmount), counts = exampleCounts
        let errorMargin = 0.2
        
        //daily: week, month and alltime
        XCTAssertEqual(counts.calculateAverage(for: id, timespan: .week, interval: .daily), amount, accuracy: amount * errorMargin)
        XCTAssertEqual(counts.calculateAverage(for: id, timespan: .month, interval: .daily), amount, accuracy: amount * errorMargin)
        XCTAssertEqual(counts.calculateAverage(for: id, timespan: .alltime, interval: .daily, from: startID), amount, accuracy: amount * errorMargin)
        
        //weekly: month, alltime
        XCTAssertEqual(counts.calculateAverage(for: id, timespan: .month, interval: .weekly), amount * 7, accuracy: (amount * 7) * errorMargin)
        XCTAssertEqual(counts.calculateAverage(for: id, timespan: .alltime, interval: .weekly, from: startID), amount * 7, accuracy: (amount * 7) * errorMargin)
        
        //monthly: alltime
        XCTAssertEqual(counts.calculateAverage(for: id, timespan: .alltime, interval: .monthly, from: startID), amount * 30.4, accuracy: (amount * 30.4) * errorMargin)
    }
}
