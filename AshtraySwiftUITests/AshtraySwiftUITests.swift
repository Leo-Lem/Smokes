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
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    //TODO: figure out how to have an in-memory model without cluttering up the production code
    
    //different configurations
    func testSumCalculation() {
        sumCalculation(example: Example.random)
    }
    
    func testSumCalculationIfEmpty() {
        sumCalculation(example: Example.empty)
    }
    
    func testAverageCalculation() {
        averageCalculation(example: Example.random)
    }
    
    func testAverageCalculationIfEmpty() {
        averageCalculation(example: Example.empty)
    }
    
    //TODO: write these tests
    func testEditingOnDate() {
    }
    
    func testEditingOnDateIfEmpty() {
    }
    
    //the testing logic
    private func sumCalculation(example: Example) {
        let statsCalculator = Model.StatsCalculator(counts: example.counts, startingID: example.startID)
        let interval = Int.random(in: 30..<(example.interval-31))
        let id = Count.getID(from: example.startID.getDateWithValueAdded(interval, for: .day))
        
        //all timespans
        XCTAssertEqual(Int(statsCalculator.sum(for: id, timespan: .day)),
                       example.amount)
        XCTAssertEqual(Int(statsCalculator.sum(for: id, timespan: .week)),
                       example.amount * 7)
        XCTAssertEqual(Int(statsCalculator.sum(for: id, timespan: .month)),
                       example.amount * id.asDateComponents.daysInMonth, accuracy: example.amount * 2)
        XCTAssertEqual(Int(statsCalculator.sum(for: id, timespan: .alltime)),
                       example.amount * interval, accuracy: example.amount * 2)
        
        print(example.description +
            """
            Tested with:
                Interval \(interval),
                ID \(id)
            
            """)
    }
    
    private func averageCalculation(example: Example) {
        let statsCalculator = Model.StatsCalculator(counts: example.counts, startingID: example.startID)
        let interval = Int.random(in: 30..<(example.interval-31))
        let id = Count.getID(from: example.startID.getDateWithValueAdded(interval, for: .day))
        let errorMargin = 0.2 //because of the way these averages are calculated
        
        //daily: week, month and alltime
        XCTAssertEqual(statsCalculator.average(for: id, timespan: .week, interval: .daily),
                       Double(example.amount), accuracy: Double(example.amount) * errorMargin)
        XCTAssertEqual(statsCalculator.average(for: id, timespan: .month, interval: .daily),
                       Double(example.amount), accuracy: Double(example.amount) * errorMargin)
        XCTAssertEqual(statsCalculator.average(for: id, timespan: .alltime, interval: .daily),
                       Double(example.amount), accuracy: Double(example.amount) * errorMargin)
        
        //weekly: month, alltime
        XCTAssertEqual(statsCalculator.average(for: id, timespan: .month, interval: .weekly),
                       Double(example.amount) * 7, accuracy: (Double(example.amount) * 7) * errorMargin)
        XCTAssertEqual(statsCalculator.average(for: id, timespan: .alltime, interval: .weekly),
                       Double(example.amount) * 7, accuracy: (Double(example.amount) * 7) * errorMargin)
        
        //monthly: alltime
        XCTAssertEqual(statsCalculator.average(for: id, timespan: .alltime, interval: .monthly),
                       Double(example.amount) * 30.4, accuracy: (Double(example.amount) * 30.4) * errorMargin)
        
        print(example.description +
            """
            Tested with:
                Interval \(interval),
                ID \(id),
                Error-Margin \(errorMargin)
            
            """)
    }
    
    /*private func editOnDate() {
        let interval = Int.random(in: 30..<(exampleInterval-31))
        let id = Count.getID(from: model.startingID.getDateWithValueAdded(interval, for: .day))
        let editAmount = exampleAmount
        
        //adding
        model.edit(amount: editAmount, for: id)
        XCTAssertEqual(Int(model.calculateSum(for: id, timespan: .day)), amount + editAmount)
        
        //removing
        model.edit(amount: -editAmount, for: id)
        //XCTAssertEqual(Int(model.calculateSum(for: id, timespan: .day)), 0)
        
        print("""
            \nTested with:
                ID: \(id),
                Interval: \(interval),
                Amount: \(editAmount)\n
            """)
    }*/
}
