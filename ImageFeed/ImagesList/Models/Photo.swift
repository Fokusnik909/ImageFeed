//
//  Photo.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 18.05.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: URL
    let fullImageURL: URL
    private(set)var isLiked: Bool
    
    mutating func toggledIsLiked()  {
           isLiked = !isLiked
        }
}
