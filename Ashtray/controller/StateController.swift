//  Created by Leopold Lemmermann on 20.01.22.

import Foundation
import MyOthers

final class StateController: ObservableObject {
  private(set) var preferences: Preferences = .default {
    willSet { objectWillChange.send() }
  }
    
  private(set) var entries: [Entry] = [] {
    willSet { objectWillChange.send() }
    didSet { entries = entries.filter { $0.amount > 0 } }
  }
    
  let calculationController: CalculationController
  let transferController: TransferController
  let localStorageController: StorageController
  let cloudStorageController: StorageController
    
  init(
    localStorageController: StorageController = LocalStorageController(),
    calculationController: CalculationController = CalculationControllerImpl(),
    transferController: TransferController = TransferControllerImpl(),
    cloudStorageController: StorageController = CloudStorageController()
  ) {
    self.calculationController = calculationController
    self.transferController = transferController
    self.localStorageController = localStorageController
    self.cloudStorageController = cloudStorageController
        
    Task {
      do {
        self.preferences = try await loadPrefs()
        self.entries = try await loadEntries()
                
        if preferences.cloudStore {
          self.preferences = try await loadPrefs(cloud: true)
          self.entries = try await loadEntries(cloud: true)
        }
      } catch { print(error) }
    }
        
    // self.entries = entries.map { Entry($0.id.startOfDay()!, amount: $0.amount) } //conversion from the old dates
  }
}

// MARK: - editing entries

extension StateController {
  func add(_ amount: Int, on date: Date) throws {
    if let index = getIndex(Entry(date)) {
      entries[index].amount += amount
    } else {
      let entry = Entry(date, amount: amount)
            
      entries.append(entry)
    }
        
    do { try saveEntries() } catch { print(error) }
  }
    
  private func getIndex(_ entry: Entry) -> Int? { entries.firstIndex { $0.id == entry.id } }
}

// MARK: - storage

extension StateController {
  func saveEntries() throws {
    Task {
      try await localStorageController.save(self.entries)
      if preferences.cloudStore { try await cloudStorageController.save(self.entries) }
    }
  }
    
  func savePrefs() throws {
    Task {
      try await localStorageController.save(self.preferences)
      if preferences.cloudStore { try await cloudStorageController.save(self.preferences) }
    }
  }
    
  func loadEntries(cloud: Bool = false) async throws -> [Entry] {
    try await cloud ? cloudStorageController.load() : localStorageController.load()
  }
    
  func loadPrefs(cloud: Bool = false) async throws -> Preferences {
    try await cloud ? cloudStorageController.load() : localStorageController.load()
  }
}

// MARK: - calculation

extension StateController {
  struct Total: Hashable {
    enum Timespan { case thisday, thisweek, thismonth, alltime }
        
    let kind: Timespan, date: Date
  }
    
  func calculate(total: Total) async -> Int {
    let timespan: Calculation.Timespan
        
    switch total.kind {
    case .thisday: timespan = .day(total.date)
    case .thisweek: timespan = .week(total.date)
    case .thismonth: timespan = .month(total.date)
    case .alltime: timespan = .alltime(total.date, preferences.startDate)
    }
        
    return await calculationController.calculateTotal(for: timespan, in: entries)
  }
    
  struct Average: Hashable {
    enum Timespan { case thisweek, thismonth, alltime }
    enum Interval { case daily, weekly, monthly }
        
    let date: Date
    var kind: (Timespan, Interval) { (timespan, interval) }
    private let timespan: Timespan, interval: Interval
        
    init(kind: (Timespan, Interval), date: Date) {
      self.timespan = kind.0
      self.interval = kind.1
      self.date = date
    }
  }
    
  func calculate(average: Average) async -> Double {
    let timespan: Calculation.Timespan, interval: Calculation.Interval
        
    switch average.kind {
    case (.thisweek, .daily):
      timespan = .week(average.date)
      interval = .daily
    case (.thismonth, .daily):
      timespan = .month(average.date)
      interval = .daily
    case (.alltime, .daily):
      timespan = .alltime(average.date, preferences.startDate)
      interval = .daily
    case (.thismonth, .weekly):
      timespan = .month(average.date)
      interval = .weekly
    case (.alltime, .weekly):
      timespan = .alltime(average.date, preferences.startDate)
      interval = .weekly
    case (.alltime, .monthly):
      timespan = .alltime(average.date, preferences.startDate)
      interval = .monthly
    default: return 0
    }
        
    return await calculationController.calculateAverage(for: timespan, with: interval, in: entries)
  }
}

// MARK: - preferences

extension StateController {
  func editPreferences(
    startDate: Date? = nil,
    cloudStore: Bool? = nil
  ) throws {
    preferences.startDate ?= startDate
    preferences.cloudStore ?= cloudStore
        
    do {
      try savePrefs()
      if cloudStore == true { try saveEntries() }
    } catch { print(error) }
  }
    
  struct Preferences: Codable {
    var startDate: Date
    var cloudStore: Bool
        
    static let `default` = Preferences(startDate: Date(), cloudStore: true)
  }
}

typealias Preferences = StateController.Preferences

// MARK: - transfer

extension StateController {
  func getFile() -> JSONFile { JSONFile(preferences, entries) }
    
  func export(result: Result<URL, Error>) async throws {
    try await transferController.export(result: result)
  }
    
  func `import`(result: Result<[URL], Error>) async throws {
    let (prefs, entries) = try await transferController.import(result: result)
    
    preferences = prefs
    self.entries = entries
        
    try saveEntries()
    try savePrefs()
        
    throw TransferControllerImpl.Status.importSuccess
  }
}
