//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Nataliya MASSOL on 23/09/2023.
//

import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let keychainTokenKey = "BearerToken"
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: keychainTokenKey)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: keychainTokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: keychainTokenKey)
            }
        }
    }
}
