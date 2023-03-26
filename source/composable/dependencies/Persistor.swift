// Created by Leopold Lemmermann on 23.02.23.

import ComposableArchitecture
import Foundation

extension DependencyValues {
  var persistor: Persistor {
    get { self[Persistor.self] }
    set { self[Persistor.self] = newValue }
  }
}

struct Persistor {
  var writeDates: ([Date]) async throws -> Void
  var readDates: () async throws -> [Date]?
}

extension Persistor: DependencyKey {
  static let liveValue = Self { dates in
    try JSONEncoder().encode(dates)
      .write(to: try getURL())
  } readDates: {
    try JSONDecoder()
      .decode([Date].self, from: try Data(contentsOf: getURL()))
  }
  
  private static let filename = "entries.json"
  
  private static func getURL() throws -> URL {
    try FileManager.default
      .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      .appending(component: filename)
      .appendingPathExtension(for: .json)
  }
}

extension Persistor {
  static let testValue = Self(
    writeDates: unimplemented("Persistor.writeDates"),
    readDates: unimplemented("Persistor.readDates")
  )
}
