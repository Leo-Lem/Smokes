// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
import UniformTypeIdentifiers

struct File: ReducerProtocol {
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .set(file): state.file = file
    case let .setEntries(entries): state.entries = entries
    case let .setCoder(coder): state.coder = coder
    case let .setError(error): state.importError = error
      
    case .create:
      return .run { [coder = state.coder, entries = state.entries] send in
        do {
          await send(.set(DataFile(try coder.encode(entries))))
        } catch { debugPrint(error) }
      }
      
    case let .import(url):
      return .run { [coder = state.coder] send in
        do {
          let file = try DataFile(at: url)
          await send(.set(file))
          await send(.setEntries(try coder.decode(file.content)))
        } catch let error as URLError where error.code == .noPermissionsToReadFile {
          await send(.setError(.missingPermission))
        } catch is URLError {
          await send(.setError(.invalidURL))
        } catch {
          await send(.setError(.invalidFormat))
        }
      }
    }
    
    return .none
  }
  
  enum ImportError: Error, LocalizedError {
    case invalidFormat, invalidURL, missingPermission
    
    var errorDescription: String? {
      switch self {
      case .invalidFormat: return String(localized: "INVALID_FORMAT_IMPORTERROR")
      case .invalidURL: return String(localized: "INVALID_URL_IMPORTERROR")
      case .missingPermission: return String(localized: "MISSING_PERMISSION_IMPORTERROR")
      }
    }
  }
}

extension File {
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
}

extension File {
  enum Action {
    case set(DataFile?),
         setEntries([Date]),
         setCoder(Coder),
         setError(ImportError?)
    
    case create
    
    case `import`(URL)
  }
}
