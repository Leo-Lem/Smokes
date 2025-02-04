// Created by Leopold Lemmermann on 02.02.25.

import Components
import struct Dependencies.Dependency
import enum Types.Interval

public enum TimeOption: String, ConfigurableWidgetOption, Sendable {
  case sinceLast = "SINCE_LAST_SMOKE",
       longestBreak = "LONGEST_SMOKE_BREAK"
}
