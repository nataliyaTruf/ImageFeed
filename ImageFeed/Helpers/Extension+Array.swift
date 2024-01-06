//
//  ArrayExtension.swift
//  ImageFeed
//
//  Created by Nataliya TRUFANOVA on 28/12/2023.
//

import Foundation

extension Array {
    mutating func withReplaced(itemAt index: Int, newValue: Element) -> [Element] {
        guard index < self.count else { return self }
        var newArray = self
        newArray[index] = newValue
        return newArray
    }
}
