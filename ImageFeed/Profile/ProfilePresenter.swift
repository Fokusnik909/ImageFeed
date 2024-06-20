//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 19.06.2024.
//

import Foundation

public protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func updateAvatar()
    func updateProfileDetails()
    func profileImageServiceObserverSetting()
    func profileImageServiceRemoveObserver()
    func logout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?

    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(view: ProfileViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        updateProfileDetails()
        profileImageServiceObserverSetting()
        updateAvatar()
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        view?.updateAvatar(url: url)
    }
    
    func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        view?.updateProfileDetails(profile: profile)
    }

    func profileImageServiceObserverSetting() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }
      
    func profileImageServiceRemoveObserver() {
            if let observer = profileImageServiceObserver {
                NotificationCenter.default.removeObserver(observer)
            }
        }
    
    func logout() {
        let profileLogoutService = ProfileLogoutService.shared
        profileLogoutService.logout()
    }
    
}
