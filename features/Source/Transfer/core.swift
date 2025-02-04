// Created by Leopold Lemmermann on 04.02.25.

import Bundle
import Code
import ComposableArchitecture
import Foundation
import struct Extensions.DataFile
import Types

@Reducer
public struct Transfer {
  @ObservableState
  public struct State: Equatable, Sendable {
    @Shared(.fileStorage(FileManager.document_url(
      Dependency(\.bundle).wrappedValue.string("ENTRIES_FILENAME")
    )))
    public var entries = Dates()

    @Shared(.appStorage("transfer_encoding")) var encoding = Encoding.daily

    @Presents var alert: AlertState<Action.Alert>?

    var importing = false
    var exporting = false

    var preview: String?
    var file: DataFile?

    public init() {}
  }

  public enum Action: Sendable, ViewAction {
    case select(Encoding),
         updateFile(Dates),
         preview(String?),
         file(DataFile?),
         loadEntries, addEntries(Dates),
         failure(any Error)

    case alert(PresentationAction<Alert>)
    case view(View)

    public enum Alert: Equatable, Sendable {}

    @CasePathable
    public enum View: BindableAction, Sendable {
      case binding(BindingAction<State>)
      case appear
      case importButtonTapped
      case exportButtonTapped
      case `import`(Result<URL, any Error>)
      case export(Result<URL, any Error>)
    }
  }

  public var body: some Reducer<State, Action> {
    BindingReducer(action: \.view)
    Reduce { state, action in
      switch action {
      case .alert: break
      case .view(.binding): break

      case let .select(encoding):
        state.$encoding.withLock { $0 = encoding }
        return .send(.updateFile(state.entries))

      case let .updateFile(entries):
        return .run { [state] send in
          @Dependency(\.code) var code
          await send(.file(nil))
          await send(.file(DataFile(try await code.encode(entries.array, state.encoding))))
        }

      case let .file(file):
        state.file = file
        return .send(.preview(file.flatMap { String(data: $0.content, encoding: .utf8) }))

      case let .preview(preview):
        state.preview = preview

      case .loadEntries:
        if let file = state.file {
          return .run { [state] send in
            @Dependency(\.code) var code
            await send(.addEntries(Dates(try await code.decode(file.content, state.encoding))))
          }
        } else {
          preconditionFailure()
        }
      case let .addEntries(entries):
        state.$entries.withLock { $0 = entries }

      case .view(.appear):
        return .send(.updateFile(state.entries))

      case .view(.importButtonTapped):
        state.exporting = false
        state.importing = true

      case .view(.exportButtonTapped):
        state.importing = false
        state.exporting = true

      case let .view(.import(result)):
        do {
          return .concatenate(
            .send(.file(try DataFile(at: try result.get()))),
            .send(.loadEntries)
          )
        } catch {
          return .send(.failure(error))
        }
      case let .view(.export(result)):
        do {
          debugPrint(try result.get())
        } catch {
          return .send(.failure(error))
        }
      case let .failure(error):
        state.alert = AlertState { TextState(ImportError(error).localizedDescription) }
      }

      return .none
    }
    .ifLet(\.$alert, action: \.alert)
    .onChange(of: \.entries) { old, new in
      Reduce { _, _ in
        old != new ? .send(.updateFile(new)) : .none
      }
    }
  }

  public init() {}
}

extension Transfer.State {
  var filename: String { String(localized: "SMOKES_FILENAME") }

  var loadingExport: Bool { file == nil && exporting }
  var loadingImport: Bool { file == nil && importing}
}

extension Transfer {
  public enum ImportError: Error, LocalizedError, Sendable {
    case invalidFormat,
         invalidURL,
         missingPermission,
         unknown(Error)

    public var errorDescription: String? {
      switch self {
      case .invalidFormat: return String(localized: "INVALID_FORMAT_IMPORTERROR")
      case .invalidURL: return String(localized: "INVALID_URL_IMPORTERROR")
      case .missingPermission: return String(localized: "MISSING_PERMISSION_IMPORTERROR")
      case let .unknown(error): return error.localizedDescription // TODO: add default error message
      }
    }

    public init(_ error: any Error) {
      self = switch error {
      case let error as URLError where error.code == .noPermissionsToReadFile: .missingPermission
      case is URLError: .invalidURL
      case is DecodingError: .invalidFormat
      case let error as CocoaError where error.isCoderError: .invalidFormat
      default: .unknown(error)
      }
    }
  }
}
