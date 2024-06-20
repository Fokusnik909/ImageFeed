//
//  ImagesListPresenterStub.swift
//  ImageFeedTests
//
//  Created by Артур  Арсланов on 20.06.2024.
//

import ImageFeed
import Foundation

final class ImagesListPresenterStub: ImagesListPresenterProtocol {
    var view: ImageListViewControllerProtocol?
    var imageListCountValue = 0
    var passImageValue: Photo?
    
    func viewDidLoad() {}
    func removeObserver() {}
    func fetchNextPageIfNeeded(at indexPath: IndexPath) {}
    func imageListCount() -> Int { return imageListCountValue }
    func updateTableViewAnimated() {}
    func passImage(at indexPath: IndexPath) -> Photo? { return passImageValue }
    func profileImageServiceRemoveObserver() {}
    func didTapLike(at indexPath: IndexPath, completion: @escaping (Result<Bool, Error>) -> Void) {}
}
