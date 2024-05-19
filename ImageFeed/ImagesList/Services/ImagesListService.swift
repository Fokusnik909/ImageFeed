//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 18.05.2024.
//

import Foundation

final class ImagesListService {
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    private var currentTask: URLSessionTask?
    private let token = OAuth2TokenStorage()
    
    func fetchPhotosNextPage() {
        guard currentTask != nil else { return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let request = makePhotosRequest(page: nextPage) else {
            print(NetworkError.invalidRequest)
            return
        }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) {
            [weak self] (result: Result<PhotoResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let resultPhoto):
                if let convertedPhoto = self.convertPhoto(from: resultPhoto){
                    self.photos.append(convertedPhoto)
                    lastLoadedPage = nextPage
                    NotificationCenter.default.post(name: Self.didChangeNotification, object: nil)
                }
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
        guard let thumbImageURL = URL(string: photo.urls.thumb) else {
            print("[ImagesListService] [convertPhoto] thumbImageURL")
            return nil
        }
        
        guard let largeImageURL = URL(string: photo.urls.full) else {
            print("[ImagesListService] [convertPhoto] largeImageURL")
            return nil
        }
        
        guard let date = photo.createdAt else {
            print("[ImagesListService] [convertPhoto] date")
            return nil
        }
        
        let dateString = formatDate(dateString: date)
        
        return Photo(id: photo.id,
                     size: CGSize(width: photo.width, height: photo.height),
                     createdAt: date,
                     welcomeDescription: photo.description,
                     thumbImageURL: thumbImageURL,
                     largeImageURL: largeImageURL,
                     isLiked: photo.likedByUser)
    }
    
    private  func formatDate(dateString: String, format: String = "yyyy-MM-dd") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else {
            print("[ImagesListService] [formatDate]")
            return nil
        }
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
}


