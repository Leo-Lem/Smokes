// Created by Leopold Lemmermann on 09.02.25.

import ComposableArchitecture
import Foundation

@Reducer
public struct Info {
  public struct State: Equatable {
    public init() {}
  }

  public enum Action: Sendable {
    case openSupport,
         openPrivacy,
         openMarketing
  }

  public var body: some Reducer<State, Action> {
    Reduce { _, action in
      let name = switch action {
      case .openSupport: "SupportUrl"
      case .openPrivacy: "PrivacyUrl"
      case .openMarketing: "MarketingUrl"
      }
      return .run { [open] _ in
        await open(Bundle.main[url: name])
      }
    }
  }

  @Dependency(\.openURL) var open

  public init() {}
}
