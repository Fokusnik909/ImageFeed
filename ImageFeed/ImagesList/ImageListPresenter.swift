//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 20.06.2024.
//

import Foundation

public protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImageListViewControllerProtocol? { get set }
}
