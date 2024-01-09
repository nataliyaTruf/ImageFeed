//
//  ImagesListServiceMock.swift
//  ImageFeedTests
//
//  Created by Nataliya MASSOL on 09/01/2024.
//

@testable import ImageFeed
import Foundation

final class ImagesListServiceMock: ImagesListServiceProtocol {
    var fetchPhotosNextPageCalled = false
    var changeLikeCalled = false
    
    var photos: [Photo] = []
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
        let photo1 = Photo(id: "1", size: CGSize(width: 100, height: 100),
                           createdAt: Date(), welcomeDescription: "Description 1",
                           thumbImageURL: "url1", largeImageURL: "url2",
                           smallImageURL: "url3", isLiked: false)
        let photo2 = Photo(id: "2", size: CGSize(width: 100, height: 100),
                           createdAt: Date(), welcomeDescription: "Description 2",
                           thumbImageURL: "url4", largeImageURL: "url5",
                           smallImageURL: "url6", isLiked: true)
        photos = [photo1, photo2]
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        changeLikeCalled = true
        if let index = photos.firstIndex(where: { $0.id == photoId }) {
            photos[index].isLiked = isLike
        }
        completion(.success(()))
    }
    func clearImagesListData() {
        
    }
}
