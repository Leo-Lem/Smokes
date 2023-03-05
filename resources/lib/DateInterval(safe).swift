// Created by Leopold Lemmermann on 05.03.23.

import Foundation

extension DateInterval {
  init?(start: Date, safeEnd: Date) {
    if start <= safeEnd { self.init(start: start, end: safeEnd) } else { return nil }
  }
}
