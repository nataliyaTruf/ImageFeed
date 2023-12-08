//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Created by Nataliya TRUFANOVA on 23/09/2023.
//

import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()

    private init() {}
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: Constants.bearerToken)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: Constants.bearerToken)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Constants.bearerToken)
            }
        }
    }
}
