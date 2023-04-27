// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
import SwiftUI

extension Porter {
  enum ViewAction {
    case createFile
    case selectCoder(Format)
    case importFile(URL)
    case dismissError
    
    static func send(_ action: Self) -> MainReducer.Action {
      switch action {
      case .createFile: return .createFile
      case let .selectCoder(coder): return .file(.setCoder(coder.coder))
      case let .importFile(url): return .file(.import(url))
      case .dismissError: return .file(.setError(nil))
      }
    }
  }
}
