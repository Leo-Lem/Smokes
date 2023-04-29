// Created by Leopold Lemmermann on 28.04.23.

import ComposableArchitecture
@testable import SmokesReducers
import XCTest

@MainActor
final class EntriesTests: XCTestCase {
  func test_whenAddingDate_thenAddsToEntries() async throws {
    let base = Date(timeIntervalSinceReferenceDate: 0)
    let dates = [base - 999_999, base, base + 999_999]
    
    let store = TestStore(initialState: [], reducer: Entries())
    
    for date in dates {
      await store.send(.add(date)) { $0.append(date) }
      await store.receive(/.change, timeout: 1)
    }
  }
  
  func test_whenRemovingDate_thenRemovesFromEntries() async throws {
    let base = Date(timeIntervalSinceReferenceDate: 0)
    let dates = [base - 999_999, base, base + 999_999]
    
    let store = TestStore(initialState: .init(dates), reducer: Entries()) { $0.calendar = .current }
    
    for date in dates {
      await store.send(.remove(date)) { $0.removeFirst() }
      await store.receive(/.change, timeout: 1)
    }
  }
  
  func test_givenEntriesAreEmpty_whenRemovingDate_thenNoChange() async throws {
    let base = Date(timeIntervalSinceReferenceDate: 0)
    let dates = [base - 999_999, base, base + 999_999]
    
    let store = TestStore(initialState: [], reducer: Entries())
    
    for date in dates {
      await store.send(.remove(date))
      await store.receive(/.change, timeout: 1)
    }
  }
  
  func test_givenEntriesIsNotEmpty_whenGettingStartDate_thenReturnsStartOfDayOfMinimum() async throws {
    withDependencies { $0.calendar = .current } operation: {
      let entries = Entries.State([Date(), Date().addingTimeInterval(86400)])
      let expectedStartDate = Calendar.current.startOfDay(for: entries.array.min()!)
      
      XCTAssertEqual(entries.startDate, expectedStartDate)
    }
  }
   
  func test_givenEntriesIsEmpty_whenGettingStartDate_thenReturnsStartOfToday() async throws {
    withDependencies {
      $0.calendar = .current
      $0.date = .constant(.now)
    } operation: {
      let entries = Entries.State([])
       
      XCTAssertEqual(entries.startDate, Calendar.current.startOfDay(for: Date()))
    }
  }
   
  func test_whenClampingAlltime_thenStartsAtStartDateAndEndsAtEndOfToday() async throws {
    withDependencies {
      $0.calendar = .current
      $0.date = .constant(.now)
    } operation: {
      let entries = Entries.State([Date(), Date().addingTimeInterval(86400)])
       
      XCTAssertEqual(entries.clamp(.alltime).start, entries.startDate)
      XCTAssertEqual(entries.clamp(.alltime).end, entries.endDate)
    }
  }
   
  func test_whenClampingTo_thenStartsAtStartDate() async throws {
    withDependencies {
      $0.calendar = .current
      $0.date = .constant(.now)
    } operation: {
      let entries = Entries.State([Date(), Date().addingTimeInterval(86400)])
      
      XCTAssertEqual(entries.clamp(.to(Date())).start!, entries.startDate)
    }
  }
   
  func test_whenClampingFrom_thenEndsAtEndDate() async throws {
    withDependencies {
      $0.calendar = .current
      $0.date = .constant(.now)
    } operation: {
      let entries = Entries.State([Date(), Date().addingTimeInterval(86400)])
      
      XCTAssertEqual(entries.clamp(.from(Date())).end!, entries.endDate)
    }
  }
}
