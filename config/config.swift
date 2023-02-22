//	Created by Leopold Lemmermann on 06.12.22.

import SwiftUI

enum Config {
  static let id = (
    bundle: "LeoLem.ashtray",
    group: "group.LeoLem.ashtray"
  )
  
  static let style = (
    fontName: "Helvetica",
    background: Color.black
  )

  static var containerURL: URL {
    FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Config.id.group)!
  }

  static var appname: String {
    (Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String)!
  }
}
