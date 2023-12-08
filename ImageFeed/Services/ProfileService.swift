//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Created by Nataliya TRUFANOVA on 06/10/2023.
//

import Foundation


final class ProfileService {
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private let requestBuilder = URLRequestBuilder.shared
    private(set) var profile: Profile?
    private var task: URLSessionTask?
   
    private init() {}
    
    func fetchProfile(completion: @escaping (Result <Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        guard let request = profileRequest() else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let profilDetails):
                let profile = Profile(result: profilDetails)
                self.profile = profile
                completion(.success(profile))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

extension ProfileService {
    private func profileRequest() -> URLRequest? {
        requestBuilder.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET"
        )
    }
}

