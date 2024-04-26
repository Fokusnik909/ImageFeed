//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 17.04.2024.
//

import Foundation


final class OAuth2TokenStorage {
    private enum Keys: String {
        case bearerToken
    }
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.bearerToken.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: Keys.bearerToken.rawValue)
        }
    }
}
