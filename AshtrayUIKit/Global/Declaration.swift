//
//  declaration.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 31.03.21.
//

import Foundation; import UIKit

let defaults = UserDefaults.standard, calendar = Calendar.current, dateFormatter = DateFormatter()

var dayCountDictionary = [String: Int] (), weekCountDictionary = [String: Int] (), monthCountDictionary = [String: Int] (), yearCountDictionary = [String: Int] ()
var alltimeCount = 0
var installationDate = "01.01.2021"
