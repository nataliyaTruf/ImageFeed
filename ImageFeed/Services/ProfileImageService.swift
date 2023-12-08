//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Nataliya TRUFANOVA on 10/10/2023.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private let urlSession = URLSession.shared
    private let requestBuilder = URLRequestBuilder.shared
    private(set) var avatarURL: String?
    private var task: URLSessionTask?
    
    private init() {}
    
    func fetchProfileImageURL(
        username: String
        // completion: @escaping (Result<String,Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        task?.cancel()
        guard let request = profileImageRequest(username: username) else {
            assertionFailure("\(NetworkError.invalidRequest)")
           //  completion(.failure(NetworkError.invalidRequest))
            return
        }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result <UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profilPhoto):
                guard let profileImageURLString = profilPhoto.profileImage?.large else { return } // поменяла размер на large
                self.avatarURL = profileImageURLString
                // completion(.success(profileImageURLString))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": profileImageURLString])
                self.task = nil
            case .failure(let error):
                //completion(.failure(error))
                assertionFailure(error.localizedDescription)
            }
        }
        self.task = task
        task.resume()
    }
}

extension ProfileImageService {
    private func profileImageRequest(username: String) -> URLRequest? {
        requestBuilder.makeHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "GET"
        )
    }
}

