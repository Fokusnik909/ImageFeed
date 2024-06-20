//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 20.06.2024.
//

import Foundation

public protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImageListViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func fetchNextPageIfNeeded(at indexPath: IndexPath)
    func imageListCount() -> Int
    func updateTableViewAnimated()
    func passImage(at indexPath: IndexPath) -> Photo?
    func removeObserver()
    func didTapLike(at indexPath: IndexPath, completion: @escaping (Result<Bool, Error>) -> Void)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImageListViewControllerProtocol?
    private let imagesListService = ImagesListService.shared
    private(set) var imageList = [Photo]()
    private var imagesListServiceObserver: NSObjectProtocol?
    
    init(view: ImageListViewControllerProtocol?) {
        self.view = view
    }
    
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
        setupObserver()
    }
    
    @objc func updateTableViewAnimated() {
        let oldCount = imageList.count
        let newCount = imagesListService.imageList.count
        imageList = imagesListService.imageList
        if oldCount != newCount {
            let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
            view?.updateTableViewAnimated(with: indexPaths)
        }
    }
    
    func imageListCount() -> Int {
        return imageList.count
    }
    
    func fetchNextPageIfNeeded(at indexPath: IndexPath) {
        guard indexPath.row + 1 == imageList.count else { return }
        imagesListService.fetchPhotosNextPage()
    }
    
    func passImage(at indexPath: IndexPath) -> Photo? {
        guard indexPath.row < imageList.count else { return nil }
        return imageList[indexPath.row]
    }
    
    func setImageList(_ photos: [Photo]) { // Метод для тестов
        self.imageList = photos
    }
    
    func didTapLike(at indexPath: IndexPath, completion: @escaping (Result<Bool, Error>) -> Void) {
        let photo = imageList[indexPath.row]
        
        view?.isShowProgressHUD(true)
        
        imagesListService.toggleImageLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let photoIsLiked):
                self.imageList[indexPath.row] = photoIsLiked
                completion(.success(photoIsLiked.isLiked))
            case .failure(let error):
                completion(.failure(error))
            }
            view?.isShowProgressHUD(false)
        }
    }
    
    //MARK: - Observer Setting
    private func setupObserver() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateTableViewAnimated()
        }
    }
    
    func removeObserver() {
        if let observer = imagesListServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

