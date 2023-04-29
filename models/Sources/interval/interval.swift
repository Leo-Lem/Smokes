// Created by Leopold Lemmermann on 02.04.23.

import Foundation

public enum Interval {
  case day(Date), week(Date), month(Date), year(Date)
  case alltime, from(Date), to(Date), fromTo(DateInterval)
}

extension Interval: Codable {}
