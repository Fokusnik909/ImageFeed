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
    
    // MARK: - Private Properties
    private (set) var imageList: [Photo] = []
    private var lastLoadedPage: Int?
    private var currentTask: URLSessionTask?
    private let oauthToken = OAuth2TokenStorage()
    private let dateFormatter8601 = ISO8601DateFormatter()
    private let session = URLSession.shared
    
    private lazy var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM yyyy"
            formatter.locale = Locale(identifier: "ru_RU")
            return formatter
        }()
    
    //MARK: - Methods
    func fetchPhotosNextPage() {
        guard currentTask == nil else { return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let request = makePhotosRequest(page: nextPage) else {
            print(NetworkError.invalidRequest)
            return
        }
        
        let task = session.objectTask(for: request) {
            [weak self] (result: Result<PhotoResultArray, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let resultPhoto):
                self.imageList.append(contentsOf: resultPhoto.compactMap(self.convertPhoto))
                lastLoadedPage = nextPage
                NotificationCenter.default.post(name: Self.didChangeNotification, object: nil)
            case .failure(let failure):
                print(failure)
            }
            self.currentTask = nil
        }
        self.currentTask = task
    }
    
    func toggleImageLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Photo, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.unsplashPhotosRequest)\(photoId)/like") else {
            return
        }
        
        var request = URLRequest(url: url)
        guard let token = oauthToken.token else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = isLike ? "DELETE" : "POST"
        
        let task = session.objectTaskData(for: request) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                if let index = self.imageList.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.imageList[index]
                    let newPhoto = Photo(id: photo.id,
                                         size: photo.size,
                                         createdAt: photo.createdAt,
                                         welcomeDescription: photo.welcomeDescription,
                                         thumbImageURL: photo.thumbImageURL,
                                         fullImageURL: photo.fullImageURL,
                                         isLiked: !photo.isLiked)
                    self.imageList[index] = newPhoto
                    completion(.success(newPhoto))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func makePhotosRequest(page: Int) -> URLRequest? {
        guard let url = URL(string: "\(Constants.unsplashPhotosRequest)?page=\(page)") else {
            return nil
        }
        var request = URLRequest(url: url)
        guard let token = oauthToken.token else { return nil }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    private func convertPhoto(from photo: PhotoResult) -> Photo? {
        guard
            let thumbImageURL = URL(string: photo.urls.thumb),
            let fullImageURL = URL(string: photo.urls.full),
            let date = photo.createdAt
        else {
            print("[ImagesListService] [convertPhoto] Invalid URL or date")
            return nil
        }
        
        return Photo(id: photo.id,
                     size: CGSize(width: photo.width, height: photo.height),
                     createdAt: formatImageDate(from: date),
                     welcomeDescription: photo.description,
                     thumbImageURL: thumbImageURL,
                     fullImageURL: fullImageURL,
                     isLiked: photo.likedByUser)
    }
    
    private func formatImageDate(from dateString: String) -> String? {

        guard let date = dateFormatter8601.date(from: dateString) else {
            print("[ImagesListService] [formatDate]")
            return nil
        }
        
        return dateFormatter.string(from: date)
    }
    
    func cleanImageList() {
        imageList = []
    }
    
}

