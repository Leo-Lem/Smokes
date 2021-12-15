//
//  DateFunctions.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 31.03.21.
//

import Foundation

func getDateComps (_ date: Date) -> DateComponents {
    let comps = calendar.dateComponents([.day, .month, .year, .weekday, .weekOfYear, .hour], from: date)
    return comps
}

func normDateComps (_ comps: DateComponents) -> DateComponents {
    var compsV = comps
    
    if compsV.hour! < 6 { compsV.hour = -11 } else { compsV.hour = 13 }
    compsV.minute = 0
    compsV.second = 0
    
    compsV = getDateComps(calendar.date(from: compsV)!)
    
    return compsV
}

func convertCompsToString (_ date: DateComponents) -> String {
    let normedDate = calendar.date(from: normDateComps(date))
        
    dateFormatter.dateFormat = "dd.MM.yyyy"
    let dateString = dateFormatter.string(from: normedDate!)
    return dateString
}

func getCompsFromString (_ dateString: String) -> DateComponents {
    let date = dateFormatter.date(from: dateString)
    let comps = calendar.dateComponents([.day, .month, .year, .weekday, .weekOfYear, .hour], from: date!)
    return comps
}
