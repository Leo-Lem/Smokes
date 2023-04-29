// Created by Leopold Lemmermann on 02.04.23.

extension Interval: Hashable {
  public func hash(into hasher: inout Hasher) {
    switch self {
    case .day, .week, .month, .year:
      hasher.combine(start)
      hasher.combine(end)
    case .alltime:
      hasher.combine("alltime")
    case let .fromTo(interval):
      hasher.combine("fromTo")
      hasher.combine(interval)
    case let .from(date):
      hasher.combine("from")
      hasher.combine(date)
    case let .to(date):
      hasher.combine("to")
      hasher.combine(date)
    }
  }
}
