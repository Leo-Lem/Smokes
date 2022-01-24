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
    func testEntryZeroBound() {
        var entry = Entry(Date(), amount: 10)
        
        entry.amount -= 100
        
        XCTAssertEqual(entry.amount, 0)
    }
    
    //MARK: - test controllers
    
    //MARK: calculation controller
    func testCalculatingTotal() async {
        let date = TestData.entry.id
        
        var total = await calculateTotal(for: .day(date))
        XCTAssertEqual(total, 5)
        
        total = await calculateTotal(for: .week(date))
        XCTAssertEqual(total, 55)
        
        total = await calculateTotal(for: .month(date))
        XCTAssertEqual(total, 230)
        
        let startDate = TestData.entries[4].id
        total = await calculateTotal(for: .alltime(date, startDate))
        XCTAssertEqual(total, 350)
    }
    
    func testCalculatingAverage() async {
        let date = TestData.entry.id
        
        //day
        var average = await calculateAverage(for: .day(date), with: .daily)
        XCTAssertEqual(average, 5)
        
        //week
        average = await calculateAverage(for: .week(date), with: .daily)
        XCTAssertEqual(average, 7.5, accuracy: 0.5)
        
        //month
        average = await calculateAverage(for: .month(date), with: .daily)
        XCTAssertEqual(average, 7.5, accuracy: 0.5)
        
        average = await calculateAverage(for: .month(date), with: .weekly)
        XCTAssertEqual(average, 52.5, accuracy: 2.5)
        
        //alltime
        let startDate = TestData.entries[4].id
        average = await calculateAverage(for: .alltime(date, startDate), with: .daily)
        XCTAssertEqual(average, 7.5, accuracy: 0.5)
        
        average = await calculateAverage(for: .alltime(date, startDate), with: .weekly)
        XCTAssertEqual(average, 52.5, accuracy: 2.5)
        
        average = await calculateAverage(for: .alltime(date, startDate), with: .monthly)
        XCTAssertEqual(average, 225, accuracy: 15)
    }
    
    //MARK: storage controller
    func testSavingEntries() async throws {
        let sc = LocalStorageController()
        
        try await sc.save(TestData.entries)
    }
    
    func testLoadingEntries() async throws {
        let sc = LocalStorageController()
        
        let entries: [Entry] = try await sc.load()
        
        XCTAssertNotNil(entries)
    }
    
    func testSavingPrefs() async throws {
        let sc = LocalStorageController()
        
        try await sc.save(Preferences.default)
    }
    
    func testLoadingPrefs() async throws {
        let sc = LocalStorageController()
        
        let prefs: Preferences = try await sc.load()
        
        XCTAssertNotNil(prefs)
    }
    
    //MARK: TransferController
    func testImporting() async throws {
        //let tc = TransferController()
        //if only I knew how to test this...
    }
    
    func testExporting() async throws {
        //let tc = TransferController()
    }
    
    //MARK: - test view logic
    
}

//MARK: - private methods
extension AshtrayTests {
    private func calculateTotal(
        for timespan: CalculationTimespan
    ) async -> Int {
        let cc = CalculationController()
        let entries = TestData.entries
        
        return await cc.calculateTotal(for: timespan, in: entries)
    }
    
    private func calculateAverage(
        for timespan: CalculationTimespan,
        with interval: CalculationInterval
    ) async -> Double {
        let cc = CalculationController()
        let entries = TestData.entries
        
        return await cc.calculateAverage(for: timespan, with: interval, in: entries)
    }
}
