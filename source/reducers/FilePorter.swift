// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
import SwiftUI
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
        state.file = try SmokesFile(entries, format: state.format)
        
      case let .readFile(url):
        if url.startAccessingSecurityScopedResource() {
          defer { url.stopAccessingSecurityScopedResource() }
          state.file = try SmokesFile(at: url)
          state.format ?= state.file?.format
        }
        
      case let .setFormat(format):
        state.format = format
        if let file = state.file { return .send(.createFile(file.entries)) }
      }
    } catch { assertionFailure(error.localizedDescription) }
    
    return .none
  }
}
