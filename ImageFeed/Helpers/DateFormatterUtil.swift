//
//  DateFormatterUtil.swift
//  ImageFeed
//
//  Created by Created by Nataliya TRUFANOVA on 17/10/2023.
//

import Foundation

    let dateFormatterUtil: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
