//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Nataliya MASSOL on 23/09/2023.
//

import Foundation

final class OAuth2TokenStorage {
    private enum Keys: String {
        case token
    }
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.token.rawValue)
        }
        set {
                UserDefaults.standard.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
