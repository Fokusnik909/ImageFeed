//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 18.05.2024.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width, height: Int
    let description: String?
    let likes: Int
    let likedByUser: Bool
    let urls: UrlsPhoto
    
}

struct UrlsPhoto: Codable {
    let  raw, full, regular, small, thumb : String
}

   


