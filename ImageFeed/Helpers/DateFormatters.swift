//
//  DateFormatterUtil.swift
//  ImageFeed
//
//  Created by Created by Nataliya TRUFANOVA on 17/10/2023.
//

import Foundation

final class CustomDateFormatters {
    static let shared = CustomDateFormatters()
    
    let iso8601DateFormatter: ISO8601DateFormatter
    let dateFormatter: DateFormatter
    private init() {
        iso8601DateFormatter = ISO8601DateFormatter()
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
    }
}
