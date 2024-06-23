//
//  ProfileViewSpy.swift
//  ImageFeedTests
//
//  Created by Артур  Арсланов on 20.06.2024.
//
import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    var updateAvatarCalled = 0
    var updateAvatarURL: URL?
    
    var updateProfileDetailsCalled = 0
    var updateProfileDetailsProfile: Profile?
    
    var logoutCalled = false
    
    var profileImageServiceObserver: NSObjectProtocol?
    
    func updateAvatar(url: URL) {
        updateAvatarCalled += 1
        updateAvatarURL = url
    }
    
    func updateProfileDetails(profile: Profile) {
        updateProfileDetailsCalled += 1
        updateProfileDetailsProfile = profile
    }
}
