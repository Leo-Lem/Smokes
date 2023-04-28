// Created by Leopold Lemmermann on 05.03.23.

import Foundation

infix operator ?=: AssignmentPrecedence
public extension Optional {
  static func ?= (lhs: inout Wrapped, rhs: Wrapped?) {
    if let rhs { lhs = rhs }
  }
}
