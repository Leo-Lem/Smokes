// Created by Leopold Lemmermann on 24.04.23.

import Foundation

extension StatsView {
  enum Option: String, ConfigurableWidgetOption {
    case perday = "PER_DAY", perweek = "PER_WEEK", permonth = "PER_MONTH", peryear = "PER_YEAR"
    
    static func enabledCases(_ interval: Interval) -> [Self] {
      switch interval {
      case .month: return [.perday, .perweek]
      case .year: return [.perday, .perweek, .permonth]
      case .alltime: return [.perday, .perweek, .permonth, .peryear]
      default: return []
      }
    }
    
    var subdivision: Subdivision {
      switch self {
      case .perday: return .day
      case .perweek: return .week
      case .permonth: return .month
      case .peryear: return .year
      }
    }
  }
}

extension StatsView {
  enum PlotOption: String, ConfigurableWidgetOption {
    case byday = "BY_DAY", byweek = "BY_WEEK", bymonth = "BY_MONTH", byyear = "BY_YEAR"
    
    static func enabledCases(_ interval: Interval) -> [Self] {
      switch interval {
      case .month: return [.byday, .byweek]
      case .year: return [.byweek, .bymonth]
      case .alltime: return [.byweek, .bymonth, .byyear]
      default: return []
      }
    }
    
    var subdivision: Subdivision {
      switch self {
      case .byday: return .day
      case .byweek: return .week
      case .bymonth: return .month
      case .byyear: return .year
      }
    }
  }
}
