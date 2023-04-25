// Created by Leopold Lemmermann on 25.04.23.

import Foundation
import UniformTypeIdentifiers

protocol FileCoder {
  static var utType: UTType { get }
  
  func encode(_ entries: [Date]) -> Data
  
  func decode(_ data: Data) -> [Date]
  
  func preview(_ entries: [Date], lines: Int) -> String
}
