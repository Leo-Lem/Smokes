// Created by Leopold Lemmermann on 23.02.23.

import Foundation

public extension DependencyValues {
  var persistor: Persistor {
    get { self[Persistor.self] }
    set { self[Persistor.self] = newValue }
  }
}

public struct Persistor {
  public var writeDates: ([Date]) async throws -> Void
  public var readDates: () async throws -> [Date]?
  
  public init(writeDates: @escaping ([Date]) async throws -> Void, readDates: @escaping () async throws -> [Date]?) {
    self.writeDates = writeDates
    self.readDates = readDates
  }
}

extension Persistor: DependencyKey {
  public static var liveValue = Self(writeDates: writeDates, readDates: readDates)
  
  private static func writeDates(_ dates: [Date]) async throws {
    try JSONEncoder()
      .encode(dates)
      .write(to: try getURL())
  }
  
  private static func readDates() async throws -> [Date]? {
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
  public static let testValue = Self(
    writeDates: unimplemented("Persistor.writeDates"),
    readDates: unimplemented("Persistor.readDates")
  )
}

extension Persistor {
  public static let previewValue = Self(
    writeDates: { _ in },
    readDates: { (0..<1000).map { _ in Date(timeIntervalSinceNow: -Double.random(in: 0..<9_999_999)) } }
  )
}
