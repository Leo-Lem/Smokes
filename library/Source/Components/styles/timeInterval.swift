// Created by Leopold Lemmermann on 11.02.25.

public extension FormatStyle where Self == TimeIntervalFormatStyle {
  static var timeInterval: Self { TimeIntervalFormatStyle() }
}

public struct TimeIntervalFormatStyle: FormatStyle, Sendable {
  public init() {}

  public func format(_ time: TimeInterval) -> String {
    guard time.isFinite else {
      assert(false, "TimeInterval must be finite")
      return ""
    }
    let formatter = DateComponentsFormatter()
    formatter.maximumUnitCount = 1
    formatter.unitsStyle = .full
    return formatter.string(from: time) ?? time.formatted()
  }
}
