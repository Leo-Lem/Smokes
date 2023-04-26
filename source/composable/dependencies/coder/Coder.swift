// Created by Leopold Lemmermann on 25.04.23.

import Foundation
import UniformTypeIdentifiers

protocol Coder {
  static var utType: UTType { get }
  
  func encode(_ entries: [Date]) throws -> Data
  
  func decode(_ data: Data) throws -> [Date]
}
