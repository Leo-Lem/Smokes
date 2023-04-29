// Created by Leopold Lemmermann on 28.04.23.

import Foundation

public struct Entries: ReducerProtocol {
  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .set(entries):
      state.array = entries
      return .send(.change)
      
    
    case let .add(date):
      state.insert(date, at: state.firstIndex { date < $0 } ?? state.endIndex)
      return .send(.change)

    case let .remove(date):
      @Dependency(\.calendar) var cal: Calendar

      if
        let nearest = state.min(by: { abs($0.distance(to: date)) < abs($1.distance(to: date)) }),
        cal.isDate(nearest, inSameDayAs: date)
      {
        state.remove(at: state.firstIndex(of: nearest)!)
      }

      return .send(.change)

    default: break
    }

    return .none
  }
}

public extension Entries {
  struct State: Equatable {
    public internal(set) var array: ArrayType
    
    public init(_ entries: ArrayType) { self.array = entries }

    public var startDate: Date {
      @Dependency(\.calendar) var cal: Calendar
      @Dependency(\.date.now) var now: Date

      return cal.startOfDay(for: array.first ?? now)
    }
    
    public var endDate: Date {
        @Dependency(\.calendar) var cal: Calendar
        @Dependency(\.date.now) var now: Date
      
      return cal.endOfDay(for: now)
    }

    public func clamp(_ interval: Interval) -> Interval {
      var start = startDate, end = endDate

      switch interval {
      case .alltime: break
      case let .from(date): start = Swift.max(start, date)
      case let .to(date): end = Swift.min(end, date)
      default: return interval
      }
      
      guard start <= end else { return .fromTo(.init()) }

      return .fromTo(.init(start: start, end: end))
    }
  }
}

extension Entries.State: RangeReplaceableCollection, ExpressibleByArrayLiteral {
  public typealias ArrayType = [Date]
  public typealias Index = ArrayType.Index
  public typealias Element = ArrayType.Element

  public var startIndex: Index { array.startIndex }
  public var endIndex: Index { array.endIndex }

  public init() { array = [] }

  public init(arrayLiteral elements: Element...) { array = elements }

  public subscript(index: Index) -> Element { array[index] }

  public func index(after i: Index) -> Index { array.index(after: i) }

  public mutating func replaceSubrange<C: Collection>(
    _ subrange: Range<ArrayType.Index>, with newElements: C
  ) where ArrayType.Element == C.Element {
    array.replaceSubrange(subrange, with: newElements)
  }
}

public extension Entries {
  enum Action {
    case set([Date]),
         add(Date),
         remove(Date)

    case change
  }
}
