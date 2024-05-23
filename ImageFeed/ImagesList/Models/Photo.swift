//
//  Photo.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 18.05.2024.
//

import Foundation

struct Photo {
    let id: String
    let createdAt: String?
    let size: CGSize
    let welcomeDescription: String?
    let thumbImageURL: URL
    let largeImageURL: URL
    let isLiked: Bool
}
