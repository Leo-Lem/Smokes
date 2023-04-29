// Created by Leopold Lemmermann on 29.04.23.

import Foundation
@testable import SmokesLibrary
import struct UniformTypeIdentifiers.UTType
import XCTest

final class DataFileTests: XCTestCase {
  func test_whenCreatingWithData_thenContentMatches() throws {
    let data = Data()
    
    let file = DataFile(data)
    
    XCTAssertEqual(file.content, data)
  }
  
  func test_givenValidDataAtURL_whenCreatingFromURL_thenCreatesFile() throws {
    let expectedContent = Data([1, 2, 3])
    
    let tempDirectory = FileManager.default.temporaryDirectory
    let dir = tempDirectory.appendingPathComponent("test_dir")
      
    try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
    
    let fileURL = dir.appendingPathComponent("test_file.json")
    try expectedContent.write(to: fileURL)
    
    XCTAssertEqual(try DataFile(at: fileURL).content, expectedContent)
  }
  
  func test_givenNoDataAtURL_whenCreatingFromURL_thenThrowsError() throws {
    let url = URL(fileURLWithPath: "/path/to/invalid/file.json")
            
    XCTAssertThrowsError(try DataFile(at: url))
  }
  
  func test_givenNoPermissionAtURL_whenCreatingFromURL_thenThrowsError() throws {
    let tempDirectory = FileManager.default.temporaryDirectory
    let dir = tempDirectory.appendingPathComponent("protected_dir")
      
    try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
    try FileManager.default.setAttributes([.immutable: true], ofItemAtPath: dir.path)
    
    XCTAssertThrowsError(try DataFile(at: dir.appendingPathComponent("test_file.json")))
    
    try FileManager.default.setAttributes([.immutable: false], ofItemAtPath: dir.path)
  }
}
