//
//  Formatters.swift
//  AppStoreConnect
//
//  Created by Khoa on 16/02/2022.
//

import Foundation

struct Formatters {
    static var formatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()

    static var formatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        return formatter
    }()

    static let iso8601Formatter = ISO8601DateFormatter()
}

extension JSONDecoder.DateDecodingStrategy {
    static let customStrategy = custom { decoder in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)

        let date = Formatters.iso8601Formatter.date(from: string)
            ?? Formatters.formatter1.date(from: string)
            ?? Formatters.formatter2.date(from: string)

        guard let date = date else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid date: \(string)"
            )
        }

        return date
    }
}
