//
//  DictFunctions.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 31.03.21.
//

import Foundation

//getting keys for the dictionaries
func getKey (forDate date: String, inCase caseNo: Int) -> String {
    // cases: day=1, week=2, month=3, year=4
    var key:String
    var comps = getCompsFromString(date)
    comps.hour = 13
        
    switch caseNo {
    case 1:
        key = "d" + convertCompsToString(comps)
    case 2:
        comps.day! -= (comps.weekday! - 1)
        key = "w" + convertCompsToString(comps)
    case 3:
        comps.day! = 1
        key = "m" + convertCompsToString(comps)
    case 4:
        comps.day = 1
        comps.month = 1
        key = "y" + convertCompsToString(comps)
    default:
        print("Error: Unknown Key, returning empty string")
        key = ""
    }
    return key
}
    
//saving values to the dictionary
func saveToDict (count: Int, forKey key: String, inCase caseNo: Int) {
    // cases: day=1, week=2, month=3, year=4
    switch caseNo {
    case 1: dayCountDictionary[key] = count
    case 2: weekCountDictionary[key] = count
    case 3: monthCountDictionary[key] = count
    case 4: yearCountDictionary[key] = count
    default:print("Error: Unknown Dictionary, nothing saved")
    }
}

//getting values from the dictionary
func getFromDict (forKey key: String, inCase caseNo: Int) -> Int {
    // cases: day=1, week=2, month=3, year=4
    var count = 0
    switch caseNo {
    case 1: if dayCountDictionary[key] != nil { count = dayCountDictionary[key]! }
    case 2: if weekCountDictionary[key] != nil { count = weekCountDictionary[key]! }
    case 3: if monthCountDictionary[key] != nil { count = monthCountDictionary[key]! }
    case 4: if yearCountDictionary[key] != nil { count = yearCountDictionary[key]! }
    default: print("Error: Unknown Dictionary, returning 0")
    }
    return count
}
