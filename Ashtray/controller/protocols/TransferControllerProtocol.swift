//
//  TransferController.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 24.01.22.
//

import Foundation

protocol TransferControllerProtocol: Actor {
    func export(result: Result<URL, Error>) throws
    func `import`(result: Result<[URL], Error>) throws -> (Preferences, [Entry])
}
