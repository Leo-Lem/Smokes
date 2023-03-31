// Created by Leopold Lemmermann on 02.04.23.

import Dependencies
import Foundation

extension ReducedIntervalPicker {
  enum Selection: Hashable {
    case month(month: Int, year: Int), year(Int), alltime
    
    var dateInterval: DateInterval {
      switch self {
      case let .month(month, year):
        return .month(of: Self.cal.date(from: DateComponents(year: year, month: month))!)
      case let .year(year):
        return .year(of: Self.cal.date(from: DateComponents(year: year))!)
      case .alltime:
        return DateInterval(start: .distantPast, end: .distantFuture)
      }
    }
    
    @Dependency(\.calendar) private static var cal
  }
}

extension ReducedIntervalPicker.Selection: RawRepresentable {
  init?(rawValue: String) {
    switch rawValue.first {
    case "m":
      let slices = rawValue.dropFirst().split(separator: ".")
      if let month = Int(slices[0]), let year = Int(slices[1]) {
        self = .month(month: month, year: year)
      } else { fallthrough }
      
    case "y":
      if let year = Int(rawValue.dropFirst()) {
        self = .year(year)
      } else { fallthrough }
      
    default:
      self = .alltime
    }
  }
  
  var rawValue: String {
    switch self {
    case let .month(month, year): return "m\(month).\(year)"
    case let .year(year): return "y\(year)"
    case .alltime: return "a"
    }
  }
}

// MARK: - (DOMAINS)

extension ReducedIntervalPicker.Selection {
  func months(in bounds: DateInterval) -> [Int]? {
    guard let year else { return nil }
    let yearInterval = Self.year(year).dateInterval
    var months = [Int](), date = max(yearInterval.start, bounds.start)
    
    while date < min(yearInterval.end, bounds.end) {
      months.append(Self.cal.component(.month, from: date))
      date = Self.cal.date(byAdding: .month, value: 1, to: date)!
    }
    
    return months
  }
  
  func years(in bounds: DateInterval) -> [Int] {
    var years = [Int](), date = bounds.start
    
    while date < bounds.end {
      years.append(Self.cal.component(.year, from: date))
      date = Self.cal.date(byAdding: .year, value: 1, to: date)!
    }
    
    return years
  }
}

// MARK: - (COMPONENTS)

extension ReducedIntervalPicker.Selection {
  var month: Int? {
    switch self {
    case let .month(month, _): return month
    default: return nil
    }
  }
  
  var year: Int? {
    switch self {
    case let .year(year), let .month(_, year): return year
    default: return nil
    }
  }
}

// MARK: - (MODIFICATION)

extension ReducedIntervalPicker.Selection {
  mutating func increment(in bounds: DateInterval? = nil) {
    if let bounds, isLast(in: bounds) { return }
    
    switch self {
    case let .year(year): self = .year(year+1)
    case let .month(month, year) where month >= 12: self = .month(month: 1, year: year+1)
    case let .month(month, year): self = .month(month: month+1, year: year)
    default: break
    }
  }
  
  mutating func decrement(in bounds: DateInterval? = nil) {
    if let bounds, isFirst(in: bounds) { return }
    
    switch self {
    case let .year(year): self = .year(year-1)
    case let .month(month, year) where month <= 1: self = .month(month: 12, year: year-1)
    case let .month(month, year): self = .month(month: month-1, year: year)
    default: break
    }
  }
}

// MARK: - (ATTRIBUTES)

extension ReducedIntervalPicker.Selection {
  var hasMonth: Bool {
    if case .month = self { return true } else { return false }
  }
  
  var hasYear: Bool {
    switch self {
    case .year, .month: return true
    default: return false
    }
  }
  
  var isAlltime: Bool { self == .alltime }
  
  func isLast(in bounds: DateInterval) -> Bool {
    let endYear = Self.cal.component(.year, from: bounds.end),
        endMonth = Self.cal.component(.month, from: bounds.end)
    
    switch self {
    case let .year(year): return year >= endYear
    case let .month(month, year): return year >= endYear && month >= endMonth
    default: return true
    }
  }
  
  func isFirst(in bounds: DateInterval) -> Bool {
    let startYear = Self.cal.component(.year, from: bounds.start),
        startMonth = Self.cal.component(.month, from: bounds.start)
    
    switch self {
    case let .year(year): return year <= startYear
    case let .month(month, year): return year <= startYear && month <= startMonth
    default: return true
    }
  }
}
