import ComposableArchitecture
import Foundation

struct MainReducer: ReducerProtocol {
  struct State: Equatable {
    var entries: [Date]
    var amounts = [DateInterval: Int]()
    var filePorter = FilePorter.State()
    
    var startDate: Date { entries.first ?? Dependency(\.date.now).wrappedValue }
    
    init(_ entries: [Date] = []) { self.entries = entries }
  }
  
  enum Action {
    case setEntries([Date])
    case loadEntries, saveEntries
    case add(Date), remove(Date)
    
    case calculateAmount(DateInterval)
    case calculateAmountForAverageUntil(Date),
         calculateAmountForAverage(DateInterval)
    case calculateAmountForSubdivisionUntil(Date, Calendar.Component),
         calculateAmountForSubdivision(DateInterval, Calendar.Component)
    
    case filePorter(FilePorter.Action),
         importEntries(URL), _addImportedEntries
  }
  
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.filePorter, action: /MainReducer.Action.filePorter, child: FilePorter.init)
    
    Reduce<State, Action> { state, action in
      switch action {
      case let .setEntries(entries):
        state.entries = entries
        let intervals = state.amounts.keys
        return .run { actions in
          for interval in intervals { await actions.send(.calculateAmount(interval)) }
        }
        
      case .loadEntries:
        do {
          if let entries: [Date] = try persistor.read(id: "entries") { return .send(.setEntries(entries)) }
        } catch { debugPrint(error) }
        
      case .saveEntries:
        do { try persistor.write(state.entries, id: "entries") } catch { debugPrint(error) }
        
      case let .add(date):
        state.entries.insert(date, at: state.entries.firstIndex { date < $0 } ?? state.entries.endIndex)
        for interval in state.amounts.keys where interval.contains(date) { state.amounts[interval]? += 1 }
        
      case let .remove(date):
        if let index = state.entries.lastIndex(where: { $0 <= date }) {
          state.entries.remove(at: index)
          for interval in state.amounts.keys where interval.contains(date) { state.amounts[interval]? -= 1 }
        }
        
      case let .calculateAmount(interval):
        state.amounts[interval] = (state.entries.firstIndex { interval.end < $0 } ?? state.entries.endIndex) -
        (state.entries.firstIndex { interval.start <= $0 } ?? state.entries.endIndex)
        
      case let .calculateAmountForAverageUntil(date):
        if let interval = DateInterval(start: state.startDate, safeEnd: date) {
          return .send(.calculateAmountForAverage(interval))
        }
        
      case let .calculateAmountForAverage(interval):
        return .send(.calculateAmount(interval))
        
      case let .calculateAmountForSubdivisionUntil(date, component):
        if let interval = DateInterval(start: state.startDate, safeEnd: date) {
          return .send(.calculateAmountForSubdivision(interval, component))
        }
        
      case let .calculateAmountForSubdivision(interval, component):
        return .run { actions in
          @Dependency(\.calendar) var cal: Calendar
          var date = cal.startOfDay(for: interval.start)
          while date < interval.end {
            let nextDate = cal.date(byAdding: component, value: 1, to: date)!
            await actions.send(.calculateAmount(DateInterval(start: date, end: nextDate)))
            date = nextDate
          }
        }
        
      case let .importEntries(url):
        return .run { actions in
          await actions.send(.filePorter(.readFile(url)))
          await actions.send(._addImportedEntries)
        }
        
      case ._addImportedEntries:
        if let entries = state.filePorter.file?.entries {
          return .send(.setEntries((state.entries + entries).sorted()))
        }
        
      default: break
      }
      return .none
    }
  }
  
  @Dependency(\.persistor) private var persistor
}

extension MainReducer.State {
  func average(until date: Date, by subdivision: Calendar.Component) -> Double? {
    DateInterval(start: startDate, safeEnd: date).flatMap { average($0, by: subdivision) } ?? 0
  }
  
  func subdivide(until date: Date, by subdivision: Calendar.Component) -> [DateInterval: Int] {
    DateInterval(start: startDate, safeEnd: date).flatMap { subdivide($0, by: subdivision) } ?? [:]
  }
  
  func average(_ interval: DateInterval, by subdivision: Calendar.Component) -> Double? {
    @Dependency(\.calendar) var cal: Calendar
    let length = cal.dateComponents([subdivision], from: interval.start, to: interval.end)
      .value(for: subdivision) ?? 1
    
    return Double(amounts[interval] ?? 0) / Double(length == 0 ? 1 : length)
  }
  
  func subdivide(_ interval: DateInterval, by subdivision: Calendar.Component) -> [DateInterval: Int] {
    @Dependency(\.calendar) var cal: Calendar
    var subintervals = [DateInterval](), date = cal.startOfDay(for: interval.start)
        
    while date < interval.end {
      let nextDate = cal.date(byAdding: subdivision, value: 1, to: date)!
      subintervals.append(DateInterval(start: date, end: nextDate))
      date = nextDate
    }
    
    return .init(uniqueKeysWithValues: subintervals.map { ($0, amounts[$0] ?? 0) })
  }
}
