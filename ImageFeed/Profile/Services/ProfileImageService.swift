//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 30.04.2024.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let token = OAuth2TokenStorage()
    private (set) var avatarURL: String?
    private var currentTask: URLSessionTask?
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        currentTask?.cancel()
        
        guard let request = makeProfileImageRequest( username: username) else { return }
        let session = URLSession.shared
        let task = session.objectTask(for: request) {
            [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let photo):
                guard let avatarURL = photo.profileImage?.large else {
                    print("Error: [ProfileImageService] image is nill")
                    completion(.failure(NetworkError.imageError))
                    return
                }
                
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL])
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.currentTask = task
        task.resume()
    }
    
    private func makeProfileImageRequest( username: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let token = token.token else { return nil }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
