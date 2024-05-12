//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 26.04.2024.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    let profileImage: ProfileImage?
}
