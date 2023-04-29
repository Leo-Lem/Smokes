// Created by Leopold Lemmermann on 01.04.23.

import Foundation

public extension Calendar {
  func endOfDay(for date: Date) -> Date { startOfDay(for: date + 86400) - 1 }
  
  func start(of component: Calendar.Component, for date: Date) -> Date? {
    guard let relevant = relevant(component) else { return nil }
    
    var comps = DateComponents()
    for comp in relevant { comps.setValue(self.component(comp, from: date), for: comp) }
    guard let start = self.date(from: comps) else { return nil }
    
    return start
  }
  
  func end(of component: Calendar.Component, for date: Date) -> Date? {
    guard
      let next = self.date(byAdding: component, value: 1, to: date),
      let startOfNext = start(of: component, for: next)
    else { return nil }
    
    return startOfNext - 1
  }
  
  private func relevant(_ component: Calendar.Component) -> Set<Calendar.Component>? {
    switch component {
    case .year: return [.year]
    case .month: return [.year, .month]
    case .day: return [.year, .month, .day]
    case .hour: return [.year, .month, .day, .hour]
    case .minute: return [.year, .month, .day, .hour, .minute]
    case .second:  return [.year, .month, .day, .hour, .minute, .second]
    case .weekOfYear: return [.yearForWeekOfYear, .weekOfYear]
    default: return nil
    }
  }
}
