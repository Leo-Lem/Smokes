//
//  LocalizedOperator.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import Foundation

postfix operator ~
public postfix func ~ (string: String) -> String {
    NSLocalizedString(string, comment: "")
}
