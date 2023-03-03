// Created by Leopold Lemmermann on 23.02.23.

import ComposableArchitecture

extension DependencyValues {
  var persistor: Persistor { self[PersistorKey.self] }
}

import Foundation
private enum PersistorKey: DependencyKey {
  static let liveValue: any Persistor = ThePersistor()
  static let testValue: any Persistor = MockPersistor()
  static let previewValue: any Persistor = MockPersistor()
}

protocol Persistor {
  func write<T: Encodable>(_ encodable: T, to filename: String) throws
  func read<T: Decodable>(from filename: String) throws -> T?
}

private struct ThePersistor: Persistor {
  func write<T: Encodable>(_ encodable: T, to filename: String) throws {
    try JSONEncoder()
      .encode(encodable)
      .write(to: try getURL(filename))
  }
  
  func read<T: Decodable>(from filename: String) throws -> T? {
    try JSONDecoder()
      .decode(T.self, from: try Data(contentsOf: getURL(filename)))
    
  }
  
  private func getURL(_ filename: String) throws -> URL {
    try FileManager.default
      .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      .appending(component: filename)
      .appendingPathExtension(for: .json)
  }
}

private struct MockPersistor: Persistor {
  func write<T: Encodable>(_ encodable: T, to filename: String) throws {
    debugPrint("No data written to persistent storage (testing/previewing).")
  }
  
  func read<T: Decodable>(from filename: String) throws -> T? {
    debugPrint("No data read from persistent storage (testing/previewing).")
    return nil
  }
}
