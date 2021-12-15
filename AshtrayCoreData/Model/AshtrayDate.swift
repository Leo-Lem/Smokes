//
//  AshtrayDate.swift
//  
//
//  Created by Leopold Lemmermann on 04.12.21.
//

import Foundation
import MyDates

public protocol AshtrayDate: ConvertibleDate {
    typealias AshtrayDefaults = AshtrayDateSettings
    
    func getID() -> String
    func yesterdaysDate<T: AshtrayDate>() -> T
    func normedDate<T: AshtrayDate>() -> T
}

public class AshtrayDateSettings: ConvertibleDateSettings {
    public static var dayStartsAt: Int = 6
    public static var idFormat: (_ date: Date) -> String = { date in
        DateFormatter(withDateFormat: dateFormat).string(from: date)
    }
}

extension Date: AshtrayDate {
    public func getID() -> String {
        AshtrayDefaults.idFormat(self)
    }
    
    public func yesterdaysDate<T: AshtrayDate>() -> T {
        self.addToValues([-1], for: [.day]) as! T
    }
    
    public func normedDate<T: AshtrayDate>() -> T {
        if self.getComponents().hour! < AshtrayDefaults.dayStartsAt {
            return self.yesterdaysDate()
        } else {
            return self as! T
        }
    }
}

extension DateComponents: AshtrayDate {
    public func getID() -> String {
        AshtrayDefaults.idFormat(self.getDate())
    }
    public func yesterdaysDate<T: AshtrayDate>() -> T {
        self.getDate().addToValues([-1], for: [.day]).getComponents() as! T
    }
    public func normedDate<T: AshtrayDate>() -> T {
        if self.getComponents().hour! < AshtrayDefaults.dayStartsAt {
            return self.yesterdaysDate()
        } else {
            return self as! T
        }
    }
}

extension String: AshtrayDate {
    public func getID() -> String {
        AshtrayDefaults.idFormat(self.getDate())
    }
    public func yesterdaysDate<T: AshtrayDate>() -> T {
        self.getDate().addToValues([-1], for: [.day]).getString() as! T
    }
    public func normedDate<T: AshtrayDate>() -> T {
        if self.getComponents().hour! < AshtrayDefaults.dayStartsAt {
            return self.yesterdaysDate()
        } else {
            return self as! T
        }
    }
}

public func getID<T: AshtrayDate>(_ date: T) -> String {
    date.getID()
}
public func ystDate<T: AshtrayDate>(_ date: T) -> T {
    date.yesterdaysDate()
}
public func normedDate<T: AshtrayDate>(_ date: T) -> T {
    date.normedDate()
}
