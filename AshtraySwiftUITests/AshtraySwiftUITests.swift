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
    private var exampleCounts: [CountType] = [CountType]()
    
    override func setUpWithError() throws {
        for i in 0..<100 {
            let id = startingID.addToValues([i], for: [.day])
            exampleCounts.append(Count(id: id, amount: 2))
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExampleCountsContainsExamples() {
        XCTAssertFalse(exampleCounts.isEmpty)
    }
    
    func testSumCalculation() {
        let id = Count.getID(from: startingID.addToValues([40], for: [.day]))

        //day
        XCTAssertEqual(
            Int(exampleCounts.calculateSum(for: id, timespan: .day)),
            2
        )
        
        //week
        XCTAssertEqual(
            Int(exampleCounts.calculateSum(for: id, timespan: .week)),
            14
        )
        
        //month
        XCTAssertEqual(
            Int(exampleCounts.calculateSum(for: id, timespan: .month)),
            62
        )
        
        //alltime
        XCTAssertEqual(
            Int(exampleCounts.calculateSum(for: id, timespan: .alltime, from: startingID)),
            82
        )
    }
    
    func testAverageCalculation() {
        let id = Count.getID(from: startingID.addToValues([40], for: [.day]))
        
        //daily
        //week
        XCTAssertEqual(exampleCounts.calculateAverage(for: id, timespan: .week, interval: .daily),
                       2.0)
        //month
        XCTAssertEqual(exampleCounts.calculateAverage(for: id, timespan: .month, interval: .daily),
                       2.0)
        //alltime
        XCTAssertEqual(exampleCounts.calculateAverage(for: id, timespan: .alltime, interval: .daily, from: startingID),
                       2.0)
        
        //weekly
        //week
        
        //month
        
        //alltime
        
        
        //monthly
        //week
        
        //month
        
        //alltime
        
    }

}
