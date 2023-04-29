// Created by Leopold Lemmermann on 29.04.23.

extension Subdivision: Comparable {
  public static func < (lhs: Subdivision, rhs: Subdivision) -> Bool {
    switch (lhs, rhs) {
    case (.day, .week), (.day, .month), (.day, .year),
         (.week, .month), (.week, .year),
         (.month, .year): return true
    default: return false
    }
  }
}
