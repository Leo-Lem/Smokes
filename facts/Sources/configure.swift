// Created by Leopold Lemmermann on 30.04.23.

import Vapor

extension Application {
  func configure() {
    get() { req in
      "Hello, vapor!"
    }
  }
}

