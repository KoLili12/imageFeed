//
//  Date+from.swift
//  imageFeed
//
//  Created by Николай Жирнов on 05.02.2025.
//

import Foundation

extension Date {
    private static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()

    private static let russianFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()

    static func from(dateTimeString: String) -> Date? {
        return isoFormatter.date(from: dateTimeString)
    }

    func toRussianFormat() -> String {
        return Date.russianFormatter.string(from: self)
    }
}
