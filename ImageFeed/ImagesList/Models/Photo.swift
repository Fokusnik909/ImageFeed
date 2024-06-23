//
//  Photo.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 18.05.2024.
//

import Foundation

public struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: URL
    let fullImageURL: URL
    private(set)var isLiked: Bool
    
    public init(id: String, size: CGSize, createdAt: String?, welcomeDescription: String?, thumbImageURL: URL, fullImageURL: URL, isLiked: Bool) {
            self.id = id
            self.size = size
            self.createdAt = createdAt
            self.welcomeDescription = welcomeDescription
            self.thumbImageURL = thumbImageURL
            self.fullImageURL = fullImageURL
            self.isLiked = isLiked
        }
    
    mutating func toggledIsLiked()  {
           isLiked = !isLiked
        }
}
