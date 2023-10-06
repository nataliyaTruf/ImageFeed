//
//  SnakeCaseJSONDecoder.swift
//  ImageFeed
//
//  Created by Nataliya MASSOL on 06/10/2023.
//

import Foundation

final class SnakeCaseJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
