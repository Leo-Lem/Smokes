//
//  UDFunctions.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 31.03.21.
//

import Foundation

//saving dicts and alltimeCount to the UserDefaults
    func saveToUD () {
        defaults.set(dayCountDictionary, forKey: "uDDay")
        defaults.set(weekCountDictionary, forKey: "uDWeek")
        defaults.set(monthCountDictionary, forKey: "uDMonth")
        defaults.set(yearCountDictionary, forKey: "uDYear")
        defaults.set(alltimeCount, forKey: "uDAlltime")
    }
    
//getting dicts and alltimeCount from the UserDefaults
    func getFromUD () {
        if defaults.object(forKey:"uDDay") != nil { dayCountDictionary = defaults.object(forKey:"uDDay") as! [String: Int] }
        if defaults.object(forKey:"uDWeek") != nil { weekCountDictionary = defaults.object(forKey:"uDWeek") as! [String: Int] }
        if defaults.object(forKey:"uDMonth") != nil { monthCountDictionary = defaults.object(forKey:"uDMonth") as! [String: Int] }
        if defaults.object(forKey:"uDYear") != nil { yearCountDictionary = defaults.object(forKey:"uDYear") as! [String: Int] }
        if defaults.object(forKey:"uDAlltime") != nil { alltimeCount = defaults.object(forKey:"uDAlltime") as! Int }
    }
