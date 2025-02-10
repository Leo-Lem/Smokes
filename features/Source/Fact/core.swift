// Created by Leopold Lemmermann on 03.02.25.

import Bundle
import ComposableArchitecture
import Extensions
import Foundation

@Reducer
public struct Fact {
  @ObservableState
  public struct State: Equatable, Sendable {
    @Shared var fact: String
    var progress = 0.0

    public init(fact: String = "Coming soon…", progress: Double = 0.0) {
      _fact = Shared(wrappedValue: fact, .appStorage("smokes_fact"))
      self.progress = progress
    }
  }

  public enum Action: Sendable {
    case countdown,
         fetch,
         appear,
         dismiss
  }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .appear:
        return .merge(.send(.countdown), .send(.fetch))

      case .dismiss:
        return .run { [dismiss] _ in
#if DEBUG
          @Dependency(\.isPresented) var isPresented
          if isPresented {
            await dismiss()
          }
#else
          await dismiss()
#endif
        }

      case .countdown:
        state.progress += 0.01
        return .run { [state, clock] send in
          guard state.progress <= 0.99 else { return await send(.dismiss) }
          try? await clock.sleep(for: .milliseconds(50))
          await send(.countdown)
        }

      case .fetch:
        return .run { [state, session, bundled] _ in
          do {
            let url = URL(string: bundled("FACTS_URL"))!
              .appendingPathComponent(Locale.current.identifier)
            let (data, response) = try await session.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }

            state.$fact.withLock {
              $0 ?= String(data: data, encoding: .utf8)
            }
          } catch {
            print("Failed to fetch fact: \(error)")
          }
        }
      }
    }
  }

  @Dependency(\.urlSession) var session
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.continuousClock) var clock
  @Dependency(\.bundle.string) var bundled

  public init() {}
}
