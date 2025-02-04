// Created by Leopold Lemmermann on 03.02.25.

import Bundle
import ComposableArchitecture
import Extensions
import Foundation

@Reducer
public struct Fact {
  @ObservableState
  public struct State: Equatable, Sendable {
    @Shared(.appStorage("smokes_fact")) var fact = String(localized: "COMING_SOON")
    var countdown = 5000

    var progress: Double { 1 - Double(countdown) / 5000 }

    public init() {}
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
        state.countdown -= 50
        return .run { [state, clock] send in
          if state.countdown < 0 { await send(.dismiss) }
          try? await clock.sleep(for: .milliseconds(50))
          await send(.countdown)
        }

      case .fetch:
        return .run { [state, session, bundle] _ in
          do {
            let url = URL(string: bundle.string("FACTS_URL"))!
              .appendingPathComponent(Locale.language_code.identifier)
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
  @Dependency(\.bundle) var bundle

  public init() {}
}
