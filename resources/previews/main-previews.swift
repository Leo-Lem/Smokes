// Created by Leopold Lemmermann on 04.03.23.

import Foundation

extension MainReducer.State {
  static var preview: Self { .init((0..<1000).map { _ in Date.now - Double.random(in: 0..<10_000_000) }) }
}
