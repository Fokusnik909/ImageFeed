//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 17.04.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private enum Keys: String {
        case bearerToken
    }
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: Keys.bearerToken.rawValue)
        } set {
            guard let newValue = newValue else {
                print("[Error]: [OAuth2TokenStorage] - Save kay")
                return
            }
            KeychainWrapper.standard.set(newValue, forKey: Keys.bearerToken.rawValue)
        }
    }
}
