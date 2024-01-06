//
//  Extension+Photo.swift
//  ImageFeed
//
//  Created by Nataliya TRUFANOVA on 05/01/2024.
//

import Foundation

extension Photo {
    init(result photo: PhotoResult) {
        self.init(id: photo.id,
                  size: CGSize(width: CGFloat(photo.height), height: CGFloat(photo.height)),
                  createdAt: CustomDateFormatters.shared.iso8601DateFormatter.date(from: photo.createdAt ?? ""),
                  welcomeDescription: photo.description ?? "",
                  thumbImageURL: photo.urls.thumb,
                  largeImageURL: photo.urls.full,
                  smallImageURL: photo.urls.small,
                  isLiked: photo.likedByUser)
    }
}
