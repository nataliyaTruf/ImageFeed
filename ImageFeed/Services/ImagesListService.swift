//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Created by Nataliya TRUFANOVA on 17/10/2023.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let urlSession = URLSession.shared
    private let requestBuilder = URLRequestBuilder.shared
    private var task: URLSessionTask?
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    private init() {}
    
    func fetchPhotosNextPage() {
        task?.cancel()
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        guard let request = photosRequest(page: nextPage, perPage: 10) else {
            assertionFailure("\(NetworkError.invalidRequest)")
           //  completion(.failure(NetworkError.invalidRequest))
            return
        }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let bodies):
                let newPhotos = bodies.map { Photo(result: $0) }
                print("🎾Количество фото до обновления \(self.photos.count)")
                self.photos.append(contentsOf: newPhotos)
                print("🎾🎾Количество фото после обновления \(self.photos.count)")
               //  completion(.success(newPhotos))
                self.lastLoadedPage = nextPage
                self.task = nil
                NotificationCenter.default
                    .post(
                        name: ImagesListService.DidChangeNotification,
                        object: self
                    )
            case .failure(let error):
                assertionFailure(error.localizedDescription)
                // completion(.failure(error))
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
