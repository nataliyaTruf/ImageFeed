//
//  Constants.swift
//  ImageFeed
//
//  Created by Created by Nataliya TRUFANOVA on 17/09/2023.
//

import Foundation

enum Constants {
    
    // MARK: -Unsplash API
    static let accessKey: String = "YIdDeipnqmyFrGPIPRGkH_xyqPr1WoZTsiBUG24Ug7c"
    static let secretKey: String = "35jhiuXM_bBuBfVw4WstuCw9TPNLFw88vYx5FCj8p1Q"
    static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    
    // MARK: - URLs
    static let defaultApiBaseURLString: String = "https://api.unsplash.com"
    static let baseURLString: String = "https://unsplash.com"
    static let authorizeURL: String = "https://unsplash.com/oauth/authorize"
    
    // MARK: - Storage
    static let bearerToken = "BearerToken"
    
    // MARK: - Request Parameters
    static let clientID: String = "client_id"
    static let redirect: String = "redirect_uri"
    static let responseType: String = "response_type"
    static let scope: String = "scope"
    static let code: String = "code"
    static let authorizedPath: String = "/oauth/authorize/native"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultApiBaseURLString: String
    let baseURLString: String
    let authorizeURL: String
    let code: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            defaultApiBaseURLString: Constants.defaultApiBaseURLString,
            baseURLString: Constants.baseURLString,
            authorizeURL: Constants.authorizeURL,
            code: Constants.code
        )
    }
}
