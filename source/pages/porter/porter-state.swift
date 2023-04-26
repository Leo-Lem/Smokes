// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
import SwiftUI
import UniformTypeIdentifiers

extension Porter {
  struct ViewState: Equatable {
    let file: DataFile?
    let importFailed: Bool
    
    init(_ state: MainReducer.State) {
      file = state.file.file
      importFailed = state.file.importFailed
    }
  }
}
