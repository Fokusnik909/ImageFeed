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
    
    private let networkClient: NetworkRouting = NetworkClient()
    
    //MARK: - Methods
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest {
         let baseURL = URL(string: "https://unsplash.com")!
         let url = URL(
             string: "/oauth/token"
             + "?client_id=\(Constants.accessKey)"
             + "&&client_secret=\(Constants.secretKey)"
             + "&&redirect_uri=\(Constants.redirectURI)"
             + "&&code=\(code)"
             + "&&grant_type=authorization_code",
             relativeTo: baseURL
         )!
        var request = URLRequest(url: url)
         request.httpMethod = "POST"
         
         return request
     }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let request = makeOAuthTokenRequest(code: code)
        
        networkClient.fetch(request: request) { result in
            switch result {
            case .success(let date):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let token = try decoder.decode(OAuthTokenResponseBody.self, from: date)
                    completion(.success(token.accessToken))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
