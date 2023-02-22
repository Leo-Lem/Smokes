import ComposableArchitecture
import Foundation

struct MainReducer: ReducerProtocol {
  struct State: Equatable {
    var startDate: Date
    
    var entries: [Date] {
      didSet {
        let min = entries.min() ?? .now
        if min < startDate { startDate = min }
      }
    }
    
    init(startDate: Date = .now, entries: [Date] = []) {
      (self.startDate, self.entries) = (startDate, entries)
    }
  }
  
  enum Action: Equatable {
    case add(Date)
    case remove(Date)
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .add(date):
      state.entries.append(date)
      
    case let .remove(date):
      if
        let max = state.entries.max(by: { $0.distance(to: date) < $1.distance(to: date) }),
        Calendar.current.isDate(max, inSameDayAs: date),
        let index = state.entries.firstIndex(of: max)
      {
        state.entries.remove(at: index)
      }
    }
    
    return .none
  }
}

extension MainReducer.State {
  func amount(for date: Date, in period: Calendar.Component, cal: Calendar = .current) -> Int {
    entries.filter { cal.isDate($0, equalTo: date, toGranularity: period) }.count
  }
  
  func average(
    for date: Date, in period: Calendar.Component, by subdivision: Calendar.Component,
    cal: Calendar = .current
  ) -> Double {
    let divisor = Double(cal.range(of: subdivision, in: period, for: date)?.upperBound ?? 1)
    
    return Double(amount(for: date, in: period, cal: cal)) / (divisor == 0 ? 1 : divisor)
  }
  
  func data(
    for date: Date, in period: Calendar.Component, by subdivision: Calendar.Component,
    cal: Calendar = .current
  ) -> [Date: Int] {
    let interval = cal.dateInterval(of: period, for: date)!
    var data = [Date: Int](), key = interval.start
    
    while key <= interval.end {
      data[key] = amount(for: key, in: subdivision, cal: cal)
      key = cal.date(byAdding: subdivision, value: 1, to: key) ?? interval.end
    }
    
    return data
  }
  
  func amount(from lower: Date? = nil, to upper: Date? = nil) -> Int {
    let isIncluded: (Date) -> Bool
    
    switch (lower, upper) {
    case let (.some(lower), .none): isIncluded = { lower <= $0 }
    case let (.none, .some(upper)): isIncluded = { $0 <= upper }
    case let (.some(lower), .some(upper)): isIncluded = { lower <= $0 && $0 <= upper }
    default: isIncluded = { _ in true }
    }
    
    return entries.filter(isIncluded).count
  }
  
  func average(
    from lower: Date? = nil, to upper: Date? = nil, by subdivision: Calendar.Component,
    cal: Calendar = .current
  ) -> Double {
    let amount = Double(amount(from: lower, to: upper))
    let divisor = Double(
      (cal.dateComponents([subdivision], from: lower ?? startDate, to: upper ?? .now).value(for: subdivision)!)
    )
    
    return amount / (divisor == 0 ? 1 : divisor)
  }
  
  func data(
    from lower: Date? = nil, to upper: Date? = nil, by subdivision: Calendar.Component,
    cal: Calendar = .current
  ) -> [Date: Int] {
    var data = [Date: Int](), key = lower ?? startDate
    
    while key <= upper ?? .now {
      data[key] = amount(for: key, in: subdivision, cal: cal)
      key = cal.date(byAdding: subdivision, value: 1, to: key) ?? upper ?? .now
    }
    
    return data
  }
}
