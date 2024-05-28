//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 18.05.2024.
//

import Foundation

final class ImagesListService {
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    static let shared = ImagesListService()
    
    private init() {}
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var currentTask: URLSessionTask?
    private let token = OAuth2TokenStorage()
    private let dateFormatter8601 = ISO8601DateFormatter()
    
    private lazy var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM yyyy"
            formatter.locale = Locale(identifier: "ru_RU")
            return formatter
        }()
    
    func fetchPhotosNextPage() {
        guard currentTask == nil else { return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let request = makePhotosRequest(page: nextPage) else {
            print(NetworkError.invalidRequest)
            return
        }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) {
            [weak self] (result: Result<PhotoResultArray, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let resultPhoto):
                self.photos.append(contentsOf: resultPhoto.compactMap(self.convertPhoto))
                lastLoadedPage = nextPage
                NotificationCenter.default.post(name: Self.didChangeNotification, object: nil)
                
            case .failure(let failure):
                print(failure)
            }
            self.currentTask = nil
        }
        self.currentTask = task
    }
    
    private func makePhotosRequest(page: Int) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(page)") else {
            return nil
        }
        var request = URLRequest(url: url)
        guard let token = token.token else { return nil }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    private func convertPhoto(from photo: PhotoResult) -> Photo? {
        guard
            let thumbImageURL = URL(string: photo.urls.thumb),
            let largeImageURL = URL(string: photo.urls.full),
            let date = photo.createdAt
        else {
            print("[ImagesListService] [convertPhoto] Invalid URL or date")
            return nil
        }
        
        return Photo(id: photo.id,
                     size: CGSize(width: photo.width, height: photo.height),
                     createdAt: formatDate(from: date),
                     welcomeDescription: photo.description,
                     thumbImageURL: thumbImageURL,
                     largeImageURL: largeImageURL,
                     isLiked: photo.likedByUser)
    }
    
    private func formatDate(from dateString: String) -> String? {

        guard let date = dateFormatter8601.date(from: dateString) else {
            print("[ImagesListService] [formatDate]")
            return nil
        }

        return dateFormatter.string(from: date)

    }
    
}


