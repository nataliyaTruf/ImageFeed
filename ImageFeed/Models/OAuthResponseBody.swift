//
//  OAuthResponseBody.swift
//  ImageFeed
//
//  Created by Nataliya MASSOL on 06/10/2023.
//

import Foundation

struct OAuthResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
