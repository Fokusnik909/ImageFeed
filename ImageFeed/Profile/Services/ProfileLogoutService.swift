//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 03.06.2024.
//

import Foundation
import WebKit
import SwiftKeychainWrapper

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    // MARK: - Private Properties
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared
    
    //MARK: - Methods
    func logout() {
        cleanCookies()
        cleanToken()
        cleanProfile()
        switchToSplashController()
    }
    
    private func cleanToken() {
        let oAuth2TokenStorage = OAuth2TokenStorage()
        oAuth2TokenStorage.cleanToken()
    }
    
    private func cleanProfile() {
        profileService.cleanProfile()
        profileImageService.cleanProfileImage()
        imagesListService.cleanImageList()
    }
    
    func switchToSplashController() {
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        let splashVC = SplashViewController()
        window.rootViewController = splashVC
    }

    private func cleanCookies() {
       // Очищаем все куки из хранилища
       HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
       // Запрашиваем все данные из локального хранилища
       WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
          // Массив полученных записей удаляем из хранилища
          records.forEach { record in
             WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
          }
       }
    }
}


