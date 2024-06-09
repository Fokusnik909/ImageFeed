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
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let unsplashPhotosRequest = "https://api.unsplash.com/photos/"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let unsplashTokenRequestString = "https://unsplash.com/oauth/token"
    static let path = "/oauth/authorize/native"
    static let unsplashProfileRequest = "https://api.unsplash.com/me"
    static let unsplashProfileImageRequest = "https://api.unsplash.com/users/"
}

