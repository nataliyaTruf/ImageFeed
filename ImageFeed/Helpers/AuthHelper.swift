//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Nataliya TRUFANOVA on 06/01/2024.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func fetchCode(from url: URL) -> String?
}

class AuthHelper: AuthHelperProtocol {
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest {
        let url = authURL()
        return URLRequest(url: url)
    }
    
    func authURL() -> URL {
        var urlComponents = URLComponents(string: Constants.authorizeURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: Constants.clientID, value: Constants.accessKey),
            URLQueryItem(name: Constants.redirect, value: Constants.redirectURI),
            URLQueryItem(name: Constants.responseType, value: Constants.code),
            URLQueryItem(name: Constants.scope, value: Constants.accessScope)
        ]
        if let url = urlComponents?.url {
            return url
        } else {
            fatalError("Unable to create URL")
        }
    }
    
    func fetchCode(from url: URL) -> String? {
        guard let components = URLComponents(string: url.absoluteString),
              components.path == Constants.authorizedPath,
              let codeItem = components.queryItems?.first(where: { $0.name == Constants.code})
        else { return nil }
        
        return codeItem.value
    }
}
