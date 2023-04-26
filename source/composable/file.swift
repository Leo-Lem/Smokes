// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
import UniformTypeIdentifiers

struct File: ReducerProtocol {
  struct State: Equatable {
    var file: DataFile?
    var coder: Coder = .daily
    var importFailed = false
    
    var entries: [Date]? { file.flatMap { coder.decode($0.content) } }
    
    static func == (lhs: File.State, rhs: File.State) -> Bool {
      lhs.file == rhs.file && lhs.importFailed == rhs.importFailed && type(of: lhs.coder) == type(of: rhs.coder)
    }
  }
  
  enum Action {
    case create([Date])
    case changeCoder(Coder)
    case `import`(URL)
    case dismissImportFailed
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .create(entries):
      state.file = nil
      state.file = DataFile(state.coder.encode(entries))
      
    case let .changeCoder(coder):
      if let content = state.file?.content {
        state.file = nil
        let entries = state.coder.decode(content)
        state.file = DataFile(coder.encode(entries))
      }
      state.coder = coder
        
    case let .import(url):
      do {
        state.file = nil
        state.file = try DataFile(at: url)
      } catch {
        debugPrint(error)
        state.importFailed = true
      }
        
    case .dismissImportFailed:
      state.importFailed = false
    }
    
    return .none
  }
}
