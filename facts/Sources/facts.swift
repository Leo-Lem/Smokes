// Created by Leopold Lemmermann on 30.04.23.

import Foundation

struct Facts {
  let en: [String],
      de: [String]

  init() {
    en = load("en")
    de = load("de")
    
    func load(_ languageCode: String) -> [String] {
      do {
        guard let url = Bundle.module.url(forResource: "facts-\(languageCode)", withExtension: "json") else {
          throw URLError(.badURL)
        }
        
        let data = try Data(contentsOf: url)
        
        guard let facts = try JSONSerialization.jsonObject(with: data) as? [String] else {
          throw CocoaError(.coderInvalidValue)
        }
        
        return facts
      } catch { fatalError("Failed to load facts for '\(languageCode)': \(error)") }
    }
  }
  
  func random(for languageCode: String) -> String? {
    switch languageCode {
    case "en": return en.randomElement()
    case "de": return de.randomElement()
    default: return nil
    }
  }
}
