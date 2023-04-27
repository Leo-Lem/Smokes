// Created by Leopold Lemmermann on 27.04.23.

struct IntervalAndSubdivision: Hashable {
  let interval: Interval, subdivision: Subdivision
  
  init(_ interval: Interval, _ subdivision: Subdivision) {
    self.interval = interval
    self.subdivision = subdivision
  }
}
