import Foundation

let ID = (
  BUNDLE: "LeoLem.Smokes",
  GROUP: "group.LeoLem.ashtray"
)

var CONTAINER_URL: URL { FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: ID.GROUP)! }

var LANGUAGE_CODE: Locale.LanguageCode { Locale.current.language.languageCode ?? .english }

let FACTS_URL = URL(string: "https://smokes.leolem.dev/facts")!
