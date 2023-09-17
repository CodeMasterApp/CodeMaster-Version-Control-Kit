//
//  Date.swift
//  
//
//  Created by Nevio Hirani on 17.09.23.
//

import Foundation

public extension Date {
    
    public func yearMonthDayFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Example: 2023-09-23
        return dateFormatter.string(from: self)
    }
    
    public func gitDateFormat(commitDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "E MM dd HH:mm:ss yyyy Z"
        return dateFormatter.date(from: commitDate)
    }
}
