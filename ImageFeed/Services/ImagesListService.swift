//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Created by Nataliya TRUFANOVA on 17/10/2023.
//

import Foundation

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
    func clearImagesListData()
}

final class ImagesListService: ImagesListServiceProtocol {
    static var shared: ImagesListServiceProtocol = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let urlSession = URLSession.shared
    private let requestBuilder = URLRequestBuilder.shared
    private var task: URLSessionTask?
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var nextPage: Int = 0
    
    private init() {}
    
    func fetchPhotosNextPage() {
        guard task == nil else { return }
        if let lastLoadedPage = lastLoadedPage {
            nextPage = lastLoadedPage + 1
        } else {
            nextPage = 1
        }
        
        guard let request = photosRequest(page: nextPage, perPage: 10) else {
            assertionFailure("\(NetworkError.invalidRequest)")
            return
        }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            self.task = nil
            switch result {
            case .success(let bodies):
                let newPhotos = bodies.map { Photo(result: $0) }
                self.photos.append(contentsOf: newPhotos)
                self.lastLoadedPage = self.nextPage
                self.task = nil
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self
                    )
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
        self.task = task
        task.resume()
    }
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping(Result<Void, Error>) -> Void) {
        task?.cancel()
        guard let request = isLike ? unLikeRequest(photoId: photoId) : likeRequest(photoId: photoId) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<Like, Error>) in
            guard let self = self else { return }
            self.task = nil
            switch result {
            case .success(let photoResult):
                if let index = self.photos.firstIndex(where: {$0.id == photoResult.photo?.id}) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        smallImageURL: photo.smallImageURL,
                        isLiked: !photo.isLiked
                    )
                    self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                }
                completion(.success(()))
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
            
        }
        self.task = task
        task.resume()
    }
}

private extension ImagesListService {
    func photosRequest(page: Int, perPage: Int) -> URLRequest? {
        requestBuilder.makeHTTPRequest(
            path: ("/photos?"
                   + "page=\(page)"
                   + "&&per_page=\(perPage)"),
            httpMethod: "GET"
        )
    }
    func likeRequest(photoId: String) -> URLRequest? {
        requestBuilder.makeHTTPRequest(
            path: "/photos/\(photoId)/like",
            httpMethod: "POST"
        )
    }
    func unLikeRequest(photoId: String) -> URLRequest? {
        requestBuilder.makeHTTPRequest(
            path: "/photos/\(photoId)/like",
            httpMethod: "DELETE")
        
    }
}

extension ImagesListService {
    func clearImagesListData() {
        photos.removeAll()
        lastLoadedPage = nil
        task?.cancel()
        
        NotificationCenter.default.post(
            name: ImagesListService.didChangeNotification,
            object: self)
    }
}
