// Created by Leopold Lemmermann on 27.04.23.

public struct IntervalAndSubdivision: Hashable {
  public let interval: Interval, subdivision: Subdivision
  
  public init(_ interval: Interval, _ subdivision: Subdivision) {
    self.interval = interval
    self.subdivision = subdivision
  }
}
