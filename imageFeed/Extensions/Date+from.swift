//
//  Date+from.swift
//  imageFeed
//
//  Created by Николай Жирнов on 05.02.2025.
//

import Foundation

extension Date {
    static func from(dateTimeString: String) -> Date? {
        return DateFormatter.defaultDateTime.date(from: dateTimeString)
    }
}

private extension DateFormatter {
    static let defaultDateTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
}

