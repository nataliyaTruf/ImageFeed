//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Nataliya TRUFANOVA on 05/01/2024.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let urls: UrlsResult
    let likedByUser: Bool
}
