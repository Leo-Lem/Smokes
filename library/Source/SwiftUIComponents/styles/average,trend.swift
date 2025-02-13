// Created by Leopold Lemmermann on 11.02.25.

public extension FormatStyle where Self == FloatingPointFormatStyle<Double> {
  static var average: Self { .number.rounded(increment: 0.01) }
  static var trend: Self { average.sign(strategy: .always()) }
}
