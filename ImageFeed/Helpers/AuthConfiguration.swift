//
//  Constants.swift
//  ImageFeed
//
//  Created by Created by Nataliya TRUFANOVA on 17/09/2023.
//

import Foundation

struct AuthConfiguration {
    // MARK: - API Configuration
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String

    // MARK: - URLs
    let defaultApiBaseURLString: String
    let baseURLString: String
    let authorizeURL: String

    // MARK: - Storage
    let bearerToken: String

    // MARK: - Request Parameters
    let clientID: String
    let redirect: String
    let responseType: String
    let scope: String
    let code: String
    let authorizedPath: String

    // Static instance for standard configuration
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: "_mszPFA5mX7eLbNQbzUczocDDiw15PKABL6Gip3y3-k",
            secretKey: "mo7qL9eYmbYJg1Xv4difYzb65BRjCD6dzUcHSiwBmq4",
            redirectURI: "urn:ietf:wg:oauth:2.0:oob",
            accessScope: "public+read_user+write_likes",
            defaultApiBaseURLString: "https://api.unsplash.com",
            baseURLString: "https://unsplash.com",
            authorizeURL: "https://unsplash.com/oauth/authorize",
            bearerToken: "BearerToken",
            clientID: "client_id",
            redirect: "redirect_uri",
            responseType: "response_type",
            scope: "scope",
            code: "code",
            authorizedPath: "/oauth/authorize/native"
        )
    }
}
