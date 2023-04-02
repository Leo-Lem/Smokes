// Created by Leopold Lemmermann on 02.04.23.

extension Calculator {
  static let previewValue = Self(
    amount: { _, _ in Int.random(in: 0..<999) },
    average: { _, _, _ in Double.random(in: 0..<999) },
    trend: { _, _, _ in Double.random(in: 0..<999) },
    sinceLast: { _, _ in Double.random(in: 0..<999_999) },
    longestBreak: { _ in Double.random(in: 0..<999_999) },
    averageTimeBetween: { _, _ in Double.random(in: 0..<999_999) }
  )
}
