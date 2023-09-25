//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Nataliya MASSOL on 23/09/2023.
//

import Foundation

final class OAuth2TokenStorage {
    private let tokenKey = "token"
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                UserDefaults.standard.set(newValue, forKey: tokenKey)
            } else {
                UserDefaults.standard.removeObject(forKey: tokenKey)
            }
        }
    }
}
