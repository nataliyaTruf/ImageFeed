//
//  Photo.swift
//  ImageFeed
//
//  Created by Nataliya MASSOL on 17/10/2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Codable{
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let urls: UrlsResult
    let likedByUser: Bool
}

struct UrlsResult: Codable {
    let full: String
    let thumb: String
}

extension Photo {
    init(result photo: PhotoResult) {
//        let size = CGSize(width: CGFloat(photo.height), height: CGFloat(photo.height))
//        let createdAt = DateFormatterUtil.dateFormatter.date(from: photo.createdAt ?? "")
//
        self.init(id: photo.id,
                  size: CGSize(width: CGFloat(photo.height), height: CGFloat(photo.height)),
                  createdAt: DateFormatterUtil.dateFormatter.date(from: photo.createdAt ?? ""),
                  welcomeDescription: photo.description ?? "",
                  thumbImageURL: photo.urls.thumb,
                  largeImageURL: photo.urls.full,
                  isLiked: photo.likedByUser)
    }
}
