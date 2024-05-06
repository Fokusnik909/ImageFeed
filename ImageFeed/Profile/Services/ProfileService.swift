//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 26.04.2024.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    private var currentTask: URLSessionTask?
    private var lastToken: String?
    private (set) var profile: Profile?
    private let profileImageServices = ProfileImageService.shared
    
    private init() {}
    
    func fetchProfile(token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard token != lastToken else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        currentTask?.cancel()
        lastToken = token
        
        guard let request = makeProfileRequest(token: token) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request)  {
            [weak self] (response: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let profileResult):
                let profile = Profile(profile: profileResult)
                self.profile = profile
                profileImageServices.fetchProfileImageURL(username: profile.username) {_ in }
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
            self.currentTask = nil
            self.lastToken = nil
        }
        self.currentTask = task
        
    }
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}


