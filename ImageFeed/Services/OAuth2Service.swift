//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 16.04.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() { }

    private var lastCode: String?
    private var currentTask: URLSessionTask?

    //MARK: - Methods
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard code != lastCode else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        currentTask?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request)  {
            [weak self] (response: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let success):
                let authToken = success.accessToken
                completion(.success(authToken))
            case .failure(let failure):
                completion(.failure(failure))
            }
            self.currentTask = nil
            self.lastCode = nil
        }
        self.currentTask = task
    
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.unsplashTokenRequestString) else { print("Failed to create URL from URLComponents")
            return nil
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]

        guard let url = urlComponents.url else {
            print("Failed to create URL from URLComponents")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
}
