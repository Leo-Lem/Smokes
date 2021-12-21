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
    private let model = Model()
    private var exampleInterval = 0, exampleAmount = 0, endID = CountIDType()
    private var testWithEmptyCountsArray = false
    
    override func setUpWithError() throws {
        //setting up some example data in the model
        model.startingID = Count.getID(from: Date(timeIntervalSinceReferenceDate:
                                                    Double.random(in: 0..<86400*365*20)))
        exampleInterval = Int.random(in: 61...364)
        exampleAmount = Int.random(in: 1...25)
        endID = Count.getID(from: model.startingID.getDateWithValueAdded(exampleInterval, for: .day))
        
        if !testWithEmptyCountsArray {
            for i in 0...exampleInterval {
                let id = model.startingID.getDateWithValueAdded(i, for: .day)
                model.counts.append(Count(id: id, amount: exampleAmount))
            }
        }
        
        print("""
            \nTesting with:
                Starting-ID: \(model.startingID),
                Example-Interval: \(exampleInterval),
                Example-Amount: \(exampleAmount),,
                End-ID: \(endID)\n
            """)
    }

    override func tearDownWithError() throws {
    }
    
    func testSumCalculation() {
        let amount = exampleAmount
        let interval = Int.random(in: 30..<(exampleInterval-31))
        let id = Count.getID(from: model.startingID.getDateWithValueAdded(interval, for: .day))
        
        //all timespans
        XCTAssertEqual(Int(model.calculateSum(for: id, timespan: .day)),
                       amount)
        XCTAssertEqual(Int(model.calculateSum(for: id, timespan: .week)),
                       amount * 7)
        XCTAssertEqual(Int(model.calculateSum(for: id, timespan: .month)),
                       amount * id.asDateComponents.daysInMonth, accuracy: amount * 2)
        XCTAssertEqual(Int(model.calculateSum(for: id, timespan: .alltime)),
                       amount * interval, accuracy: amount * 2)
        
        print("""
            \nTested with:
                Testing-ID: \(id),
                Testing-Interval \(interval)
            """)
    }
    
    func testAverageCalculation() {
        let amount = Double(exampleAmount)
        let interval = Int.random(in: 30..<(exampleInterval-31))
        let id = Count.getID(from: model.startingID.getDateWithValueAdded(interval, for: .day))
        let errorMargin = 0.2 //because of the way these averages are calculated
        
        //daily: week, month and alltime
        XCTAssertEqual(model.calculateAverage(for: id, timespan: .week, interval: .daily),
                       amount, accuracy: amount * errorMargin)
        XCTAssertEqual(model.calculateAverage(for: id, timespan: .month, interval: .daily),
                       amount, accuracy: amount * errorMargin)
        XCTAssertEqual(model.calculateAverage(for: id, timespan: .alltime, interval: .daily),
                       amount, accuracy: amount * errorMargin)
        
        //weekly: month, alltime
        XCTAssertEqual(model.calculateAverage(for: id, timespan: .month, interval: .weekly),
                       amount * 7, accuracy: (amount * 7) * errorMargin)
        XCTAssertEqual(model.calculateAverage(for: id, timespan: .alltime, interval: .weekly),
                       amount * 7, accuracy: (amount * 7) * errorMargin)
        
        //monthly: alltime
        XCTAssertEqual(model.calculateAverage(for: id, timespan: .alltime, interval: .monthly),
                       amount * 30.4, accuracy: (amount * 30.4) * errorMargin)
        
        print("""
            \nTested with:
                Testing-ID: \(id),
                Testing-Interval \(interval),
                Error-Margin: \(errorMargin)
            """)
    }
    
    func testAddingOnDate() {
        
    }
    
    func testRemovingOnDate() {
        
    }
    
    func testRemovingOnDateIfEmpty() {
        
    }
}
