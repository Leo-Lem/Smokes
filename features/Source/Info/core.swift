// Created by Leopold Lemmermann on 09.02.25.

import Bundle
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
      case .openSupport: "SmokesSupportUrl"
      case .openPrivacy: "SmokesPrivacyUrl"
      case .openMarketing: "SmokesMarketingUrl"
      }
      return .run { [open, string] _ in
        await open(URL(string: string(name))!)
      }
    }
  }

  @Dependency(\.openURL) var open
  @Dependency(\.bundle.string) var string

  public init() {}
}
