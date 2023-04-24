// Created by Leopold Lemmermann on 25.04.23.

import SwiftUI

@propertyWrapper
struct CodableAppStorage<Value: Codable>: DynamicProperty {
  @AppStorage private var encoded: String

  init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) {
    guard
      let data = try? JSONEncoder().encode(wrappedValue),
      let utf8String = String(data: data, encoding: .utf8)
    else { fatalError("Cannot encode \(wrappedValue)") }

    _encoded = AppStorage(wrappedValue: utf8String, key, store: store)
  }

  var wrappedValue: Value {
    get {
      guard
        let data = encoded.data(using: .utf8),
        let decoded = try? JSONDecoder().decode(Value.self, from: data)
      else { fatalError("Cannot deocde \(encoded)") }
      
      return decoded
    }
    
    nonmutating set {
      guard
        let data = try? JSONEncoder().encode(newValue),
        let utf8String = String(data: data, encoding: .utf8)
      else { fatalError("Cannot encode \(newValue)") }

      encoded = utf8String
    }
  }
  
  var projectedValue: Binding<Value> { Binding { wrappedValue } set: { wrappedValue = $0 } }
}
