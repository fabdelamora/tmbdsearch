//
//  Date+StringFormatter.swift
//  Movies
//
//  Created by Fabriccio De la Mora on 3/7/18.
//  Copyright © 2018 Fabriccio De la Mora. All rights reserved.
//

import Foundation

extension Date {
    func timezonedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.timeZone = TimeZone.current
        
        let dateString = "Release date: \(dateFormatter.string(from: self))"
        return dateString
    }
}

extension String {
    func date() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        let date = dateFormatter.date(from: self)
        return date
    }
}
