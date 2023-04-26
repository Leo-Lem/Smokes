// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
import UniformTypeIdentifiers

struct File: ReducerProtocol {
  struct State: Equatable {
    var file: DataFile?
    
    var coder: Coder = .daily
    var entries = [Date]()
    var importError: ImportError?
    
    static func == (lhs: File.State, rhs: File.State) -> Bool {
      lhs.file == rhs.file
      && type(of: lhs.coder) == type(of: rhs.coder)
      && lhs.entries == rhs.entries
      && lhs.importError == rhs.importError
    }
  }
  
  enum Action {
    case create
    case setEntries([Date]), setCoder(Coder)
    case `import`(URL)
    case clearError
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .create:
      state.file = DataFile(state.coder.encode(state.entries))
      
    case let .setEntries(entries):
      state.entries = entries
      return .send(.create)
      
    case let .setCoder(coder):
      state.coder = coder
      return .send(.create)
      
    case let .import(url):
      do {
        state.file = try DataFile(at: url)
      } catch let error as URLError where error.code == .noPermissionsToReadFile {
        state.importError = .missingPermission
      } catch {
        state.importError = .invalidURL
      }
      
    case .clearError:
      state.importError = nil
    }
    
    return .none
  }
  
  enum ImportError: Error, LocalizedError {
    case invalidFormat, invalidURL, missingPermission
    
    var errorDescription: String? {
      switch self {
      case .invalidFormat: return "INVALID_FORMAT_IMPORTERROR"
      case .invalidURL: return "INVALID_URL_IMPORTERROR"
      case .missingPermission: return "MISSING_PERMISSION_IMPORTERROR"
      }
    }
  }
}
