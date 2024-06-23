//
//  Constants.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 08.04.2024.
//

import Foundation

enum Constants {
    static let accessKey = "CJ0HTNcaAomUReoOxRC_x6zwasZsqmFgbkhFPMP17e4"
    static let secretKey = "bC1A1GRZSr_2MZYXcwsvWxlKZaENp6gcH2uLgVNS0Hc"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashPhotosRequest = "https://api.unsplash.com/photos/"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let unsplashTokenRequestString = "https://unsplash.com/oauth/token"
    static let path = "/oauth/authorize/native"
    static let unsplashProfileRequest = "https://api.unsplash.com/me"
    static let unsplashProfileImageRequest = "https://api.unsplash.com/users/"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let unsplashAuthorizeURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, unsplashAuthorizeURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
    }
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 defaultBaseURL: Constants.defaultBaseURL,
                                 unsplashAuthorizeURLString: Constants.unsplashAuthorizeURLString)
    }
}
