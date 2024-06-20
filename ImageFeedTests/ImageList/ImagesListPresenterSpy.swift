//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Артур  Арсланов on 20.06.2024.
//

import ImageFeed
import Foundation

final class ImagesListViewControllerSpy: ImageListViewControllerProtocol {
    var updateTableViewAnimatedCalled = false
    var indexPathsPassed: [IndexPath]?
    var isShowProgressHUDCalled = false
    var showProgressHUDValue: Bool = false
    
    func updateTableViewAnimated(with indexPaths: [IndexPath]) {
        updateTableViewAnimatedCalled = true
        indexPathsPassed = indexPaths
    }
    
    func isShowProgressHUD(_ hud: Bool) {
        isShowProgressHUDCalled = true
        showProgressHUDValue = hud
    }
}
