// Created by Leopold Lemmermann on 13.03.23.

import Foundation

extension Calendar {
  func endOfDay(for date: Date) -> Date {
    self.startOfDay(for: date + 86400) - 1
  }
}
