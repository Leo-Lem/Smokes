// Created by Leopold Lemmermann on 02.04.23.
// swiftlint:disable identifier_name

import struct Foundation.Date
import struct Foundation.DateInterval

public enum Interval: Codable {
  case day(Date), week(Date), month(Date), year(Date)
  case alltime, from(Date), to(Date), fromTo(DateInterval)
}

// swiftlint:enable identifier_name
