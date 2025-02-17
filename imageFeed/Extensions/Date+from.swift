//
//  Date+from.swift
//  imageFeed
//
//  Created by Николай Жирнов on 05.02.2025.
//

import Foundation

extension Date {
    static func from(dateTimeString: String) -> Date? {
        return ISO8601DateFormatter().date(from: dateTimeString)
    }

    func toRussianFormat() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: self)
    }
}
