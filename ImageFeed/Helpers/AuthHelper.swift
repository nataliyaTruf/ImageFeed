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
        var urlComponents = URLComponents(string: AuthConfiguration.standard.authorizeURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: AuthConfiguration.standard.clientID, value: AuthConfiguration.standard.accessKey),
            URLQueryItem(name: AuthConfiguration.standard.redirect, value: AuthConfiguration.standard.redirectURI),
            URLQueryItem(name: AuthConfiguration.standard.responseType, value: AuthConfiguration.standard.code),
            URLQueryItem(name: AuthConfiguration.standard.scope, value: AuthConfiguration.standard.accessScope)
        ]
        if let url = urlComponents?.url {
            return url
        } else {
            fatalError("Unable to create URL")
        }
    }
    
    func fetchCode(from url: URL) -> String? {
        guard let components = URLComponents(string: url.absoluteString),
              components.path == AuthConfiguration.standard.authorizedPath,
              let codeItem = components.queryItems?.first(where: { $0.name == AuthConfiguration.standard.code})
        else { return nil }
        
        return codeItem.value
    }
}
