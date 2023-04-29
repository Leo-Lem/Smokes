// Created by Leopold Lemmermann on 29.04.23.

import struct Foundation.Date
import struct Foundation.Calendar

public extension Interval {
  func previous(in bounds: Interval? = nil) -> Self? {
    let cal = Calendar.current
    
    if let start, let bound = bounds?.start, start <= bound { return nil }
    
    switch self {
    case let .day(date), let .week(date), let .month(date), let .year(date):
      return .day(cal.date(byAdding: Subdivision(self)!.comp, value: -1, to: date)!)
    default:
      return nil
    }
  }
}
