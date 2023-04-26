// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
import SwiftUI

extension Porter {
  enum ViewAction {
    case createFile
    case changeCoder(FileCoders)
    case importFile(URL)
    case dismissImportFailed
    
    static func send(_ action: Self) -> MainReducer.Action {
      switch action {
      case .createFile: return .createFile
      case let changeCoder(coder): return .file(.changeCoder(coder.coder))
      case let .importFile(url): return .file(.import(url))
      case .dismissImportFailed: return .file(.dismissImportFailed)
      }
    }
  }
}
