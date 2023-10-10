//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Nataliya MASSOL on 06/10/2023.
//

import Foundation


final class ProfileService {
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    
    private let requestBuilder: URLRequestBuilder
    
    init(requestBuilder: URLRequestBuilder = .shared) {
        self.requestBuilder = requestBuilder
    }
    
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result <Profile, Error>) -> Void
    ) {
        task?.cancel()
        guard let request = profileRequest(token: token) else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let profile = Profile(result: body)
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
    private func object(
        for request: URLRequest,
        completion: @escaping (Result <ProfileResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = SnakeCaseJSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileResult, Error> in
                Result { try decoder.decode(ProfileResult.self, from: data) }
            }
            completion(response)
        }
    }
    private func profileRequest(token: String) -> URLRequest? {
        requestBuilder.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET"
        )
    }
}

