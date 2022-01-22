//
//  LocalizedOperator.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import Foundation

//TODO: move to package
postfix operator ~
public postfix func ~ (string: String) -> String {
    NSLocalizedString(string, comment: "")
}
