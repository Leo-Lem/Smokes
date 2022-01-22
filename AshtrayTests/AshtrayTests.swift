//
//  AshtrayTests.swift
//  AshtrayTests
//
//  Created by Leopold Lemmermann on 17.01.22.
//

import XCTest
@testable import Ashtray

class AshtrayTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //MARK: - test model objects
    
    
    //MARK: - test view logic
    
    
    //MARK: - test controllers
    
    //MARK: state controller
    func testSavingEntries() {
        let stateController = StateController()
        let entry = TestData.entry
        stateController.entries.append(entry)
        
        XCTAssertNoThrow(try stateController.saveEntries())
    }
    
    
    func testLoadingEntries() {
        let stateController = StateController()
        
        XCTAssertNotNil(try? stateController.Entries())
    }
    
    //MARK: storage controller
    
    
    
    //MARK: calculation controller
    func testCalculatingTotal() {
        let date = TestData.entry.id
        
        var total = calculateTotal(for: .day(date))
        XCTAssertEqual(total, 5)
        
        total = calculateTotal(for: .week(date))
        XCTAssertEqual(total, 55)
        
        total = calculateTotal(for: .month(date))
        XCTAssertEqual(total, 230)
        
        let startDate = TestData.entries[4].id
        total = calculateTotal(for: .alltime(date, startDate))
        XCTAssertEqual(total, 350)
    }
    
    func testCalculatingAverage() {
        let date = TestData.entry.id
        
        //day
        var average = calculateAverage(for: .day(date), with: .daily)
        XCTAssertEqual(average, 5)
        
        //week
        average = calculateAverage(for: .week(date), with: .daily)
        XCTAssertEqual(average, 7.5, accuracy: 0.5)
        
        //month
        average = calculateAverage(for: .month(date), with: .daily)
        XCTAssertEqual(average, 7.5, accuracy: 0.5)
        
        average = calculateAverage(for: .month(date), with: .weekly)
        XCTAssertEqual(average, 52.5, accuracy: 2.5)
        
        //alltime
        let startDate = TestData.entries[4].id
        average = calculateAverage(for: .alltime(date, startDate), with: .daily)
        XCTAssertEqual(average, 7.5, accuracy: 0.5)
        
        average = calculateAverage(for: .alltime(date, startDate), with: .weekly)
        XCTAssertEqual(average, 52.5, accuracy: 2.5)
        
        average = calculateAverage(for: .alltime(date, startDate), with: .monthly)
        XCTAssertEqual(average, 225, accuracy: 15)
    }
    
    private func calculateTotal(
        for timespan: CalculationController.Timespan
    ) -> Int {
        let cc = CalculationController()
        let entries = TestData.entries
        
        return cc.calculateTotal(for: timespan, in: entries)
    }
    
    private func calculateAverage(
        for timespan: CalculationController.Timespan,
        with interval: CalculationController.Interval
    ) -> Double {
        let cc = CalculationController()
        let entries = TestData.entries
        
        return cc.calculateAverage(for: timespan, with: interval, in: entries)
    }
}
