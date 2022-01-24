//
//  CalculationController.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 24.01.22.
//

import Foundation

protocol CalculationControllerProtocol: Actor {
    func calculateTotal(
        for timespan: CalculationTimespan,
        in entries: [Entry]
    ) -> Int
    
    func calculateAverage(
        for timespan: CalculationTimespan,
        with interval: CalculationInterval,
        in entries: [Entry]
    ) -> Double
}

enum CalculationTimespan {
    case day(_ date: Date),
         week(_ date: Date),
         month(_ date: Date),
         alltime(_ date: Date, _ startDate: Date)
}
enum CalculationInterval { case daily, weekly, monthly }
