//
//  CountCategories.swift
//  AshtrayCoreData
//
//  Created by Leopold Lemmermann on 14.12.21.
//

import Foundation

class CountCategories {
    enum Main: String, CaseIterable {
        case today = "Today", yesterday = "Yesterday", thisweek = "This Week", thismonth = "This Month", alltime = "Alltime"
    }

    enum History: String, CaseIterable {
        case thisday = "This Day", thisweek = "This Week", thismonth = "This Month", alltime = "Alltime"
    }
    
    class Average {
        enum Span: String, CaseIterable {
            case thisweek = "Week", thismonth = "Month", alltime = "Alltime"
        }

        enum Interval: String, CaseIterable {
            case daily = "Daily", weekly = "Weekly", monthly = "Monthly"
        }
    }
}
