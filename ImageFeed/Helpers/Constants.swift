//
//  Constants.swift
//  ImageFeed
//
//  Created by Created by Nataliya TRUFANOVA on 17/09/2023.
//

import Foundation

enum Constants {
    static let accessKey: String = "YIdDeipnqmyFrGPIPRGkH_xyqPr1WoZTsiBUG24Ug7c"
    static let secretKey: String = "35jhiuXM_bBuBfVw4WstuCw9TPNLFw88vYx5FCj8p1Q"
    static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    
    static let defaultApiBaseURLString: String = "https://api.unsplash.com"
    static let baseURLString: String = "https://unsplash.com"
    
    static let bearerToken = "BearerToken"
}

enum WebKeys {
    static let clientID: String = "client_id"
    static let redirectURI: String = "redirect_uri"
    static let responseType: String = "response_type"
    static let scope: String = "scope"
}

enum WebConstants {
    static let authorizeURL: String = "https://unsplash.com/oauth/authorize"
    static let code: String = "code"
    static let authorizedPath: String = "/oauth/authorize/native"
}
