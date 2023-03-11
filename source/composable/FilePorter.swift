// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
import UniformTypeIdentifiers

struct FilePorter: ReducerProtocol {
  struct State: Equatable {
    var file: SmokesFile?, format: UTType = .json
  }
  
  enum Action {
    case createFile([Date]), readFile(URL)
    case setFormat(UTType)
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    do {
      switch action {
      case let .createFile(entries):
        state.file = try SmokesFile(entries.subdivide(), format: state.format)
        
      case let .readFile(url):
        if url.startAccessingSecurityScopedResource() {
          defer { url.stopAccessingSecurityScopedResource() }
          state.file = try SmokesFile(at: url)
          state.format ?= state.file?.format
        }
        
      case let .setFormat(format):
        state.format = format
        if let file = state.file { return .send(.createFile(Array(subdivisions: file.amounts))) }
      }
    } catch { assertionFailure(error.localizedDescription) }
    
    return .none
  }
}

// MARK: subdividing date array

extension Array where Element == Date {
  init(subdivisions: [Date: Int]) {
    self.init()
    
    @Dependency(\.calendar) var cal
    for date in subdivisions.keys.sorted() {
      self += Array(repeating: date, count: subdivisions[date]!)
    }
  }
  
  func subdivide(by component: Calendar.Component = .day) -> [Date: Int] {
    let sorted = sorted()
    
    @Dependency(\.calendar) var cal
    guard var date = sorted.first.flatMap(cal.startOfDay), let end = sorted.last else { return [:] }
    
    var subdivisions = [Date: Int]()
    
    while date < end {
      let nextDate = cal.date(byAdding: component, value: 1, to: date)!
      let amount = (sorted.firstIndex { nextDate < $0 } ?? endIndex) - (sorted.firstIndex { date <= $0 } ?? endIndex)
      if amount > 0 { subdivisions[date + 43200] = amount }
      date = nextDate
    }
    
    return subdivisions
  }
}
