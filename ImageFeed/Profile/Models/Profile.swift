//
//  Profile.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 26.04.2024.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    let login: String
    let bio: String?
    
    init(profile: ProfileResult){
        username = profile.username
        let firstName = profile.firstName ?? ""
        let lastName = profile.lastName ?? ""
        name = "\(firstName) \(lastName)"
        login = "@\(profile.username)"
        bio = profile.bio
    }
}

