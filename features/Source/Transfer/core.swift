// Created by Leopold Lemmermann on 04.02.25.

import Bundle
import Code
import ComposableArchitecture
import Foundation
import enum Generated.L10n
import struct Extensions.DataFile
import Types

@Reducer
public struct Transfer {
  @ObservableState public struct State: Equatable, Sendable {
    @Shared(.fileStorage(FileManager.document_url(
      Dependency(\.bundle.string).wrappedValue("ENTRIES_FILENAME")
    ))) var entries = Dates()
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
         preview(String?), file(DataFile?),
         loadEntries, addEntries(Dates),
         failure(String)

    case alert(PresentationAction<Alert>)
    public enum Alert: Equatable, Sendable {}

    case view(View)
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
      case let .select(encoding):
        state.$encoding.withLock { $0 = encoding }
        return .send(.updateFile(state.entries))

      case let .updateFile(entries):
        return .run { [state] send in
          await send(.file(nil))

          @Dependency(\.code.encode) var encode
          let dates = DataFile(try await encode(entries.array, state.encoding))
          await send(.file(dates))
        }

      case let .file(file):
        state.file = file
        return .send(.preview(file.flatMap { String(data: $0.content, encoding: .utf8) }))

      case let .preview(preview):
        state.preview = preview

      case .loadEntries:
        if let file = state.file {
          return .run { [encoding = state.encoding] send in
            @Dependency(\.code.decode) var decode
            let dates = Dates(try await decode(file.content, encoding))
            await send(.addEntries(dates))
          }
        } else {
          preconditionFailure()
        }

      case let .addEntries(entries):
        state.$entries.withLock { $0 = entries }

      case let .failure(error):
        state.alert = AlertState { TextState(error) }

      case let .view(action):
        switch action {
        case .appear:
          return .send(.updateFile(state.entries))

        case .importButtonTapped:
          state.exporting = false
          state.importing = true

        case .exportButtonTapped:
          state.importing = false
          state.exporting = true

        case let .import(result):
          do {
            return .concatenate(
              .send(.file(try DataFile(at: try result.get()))),
              .send(.loadEntries)
            )
          } catch {
            return switch error {
            case let error as URLError where error.code == .noPermissionsToReadFile:
                .send(.failure(L10n.Transfer.Error.permission))
            default:
                .send(.failure(L10n.Transfer.error))
            }
          }

        case let .export(result):
          do {
            debugPrint(try result.get())
          } catch {
            return .send(.failure(L10n.Transfer.error))
          }

        case .binding: break
        }

      case .alert: break
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
  var loadingExport: Bool { file == nil && exporting }
  var loadingImport: Bool { file == nil && importing }
}
