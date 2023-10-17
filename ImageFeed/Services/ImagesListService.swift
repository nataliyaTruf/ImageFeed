//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Nataliya MASSOL on 17/10/2023.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let urlSession = URLSession.shared
    private let requestBuilder = URLRequestBuilder.shared
    private var task: URLSessionTask?
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    private init() {}
    
    func fetchPhotosNextPage(completion: @escaping (Result <[Photo], Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        guard let request = photosRequest(page: nextPage, perPage: 10) else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<PhotoResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let body):
                let photo = Photo(result: body)
                self.photos.append(photo)
                completion(.success(self.photos))
                NotificationCenter.default
                    .post(
                        name: ImagesListService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": photo.thumbImageURL])
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

extension ImagesListService {
    private func photosRequest(page: Int, perPage: Int) -> URLRequest? {
        requestBuilder.makeHTTPRequest(path: ("/photos?"
                   + "page=\(page)"
              + "&&per_page=\(perPage)"),
            httpMethod: "GET"
        )
    }
}
