import Foundation

let ID = (
  BUNDLE: "LeoLem.ashtray",
  GROUP: "group.LeoLem.ashtray"
)

var CONTAINER_URL: URL { FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: ID.GROUP)! }

var LANGUAGE_CODE: Locale.LanguageCode { Locale.current.language.languageCode ?? .english }

let FACTS_URL = URL(string: "https://smokes.leolem.dev/facts")!

let INFO = (
  APPNAME: (Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String)!,
  LINKS: (
    WEBPAGE: URL(string: "https://smokes.leolem.dev")!,
    SUPPORT: URL(string: "https://github.com/Leo-Lem/Ashtray")!,
    PRIVACY_POLICY: URL(string: "https://smokes.leolem.dev/privacy")!
  ),
  CREDITS: (
    DEVELOPERS: ["Leopold Lemmermann"],
    DESIGNERS: ["Leopold Lemmermann"]
  )
)
