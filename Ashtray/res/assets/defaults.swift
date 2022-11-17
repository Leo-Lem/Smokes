//  Created by Leopold Lemmermann on 28.04.22.

import Foundation

internal let _defaultFont = "American Typewriter",
             _appTitle = "Ashtray",
             _defaultFilename = "Ashtray-Data",
             _backgroundImage = "background"

internal enum _Symbol { // swiftlint:disable:this type_name
  case pref, info, dismissOverlay, main, hist, stat, imprt, exprt

  var name: String {
    switch self {
    case .pref: return "gear.circle"
    case .info: return "info.circle"
    case .dismissOverlay: return "chevron.up"
    case .main: return "house.circle"
    case .hist: return "calendar.circle"
    case .stat: return "divide.circle"
    case .imprt: return "square.and.arrow.down"
    case .exprt: return "square.and.arrow.up"
    }
  }

  static prefix func ~ (symbol: _Symbol) -> String {
    symbol.name
  }
}
