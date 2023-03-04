// Created by Leopold Lemmermann on 04.03.23.

import Foundation

extension MainReducer.State {
  static var preview: Self { .init((0..<1000000).map { _ in Date.now + Double.random(in: -1000_000..<1000_000) }) }
}
