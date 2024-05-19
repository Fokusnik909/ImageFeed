//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 18.05.2024.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width, height: Int
    let description: String?
    let likes: Int
    let likedByUser: Bool
    let urls: UrlsPhoto
}

struct UrlsPhoto: Decodable {
    let thumb, raw, full, regular, small : String
}


   


