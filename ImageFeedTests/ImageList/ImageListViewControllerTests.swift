//
//  ImageListViewControllerTests.swift
//  ImageFeedTests
//
//  Created by Артур  Арсланов on 20.06.2024.
//

@testable import ImageFeed
import XCTest

class ImagesListPresenterTests: XCTestCase {
    
    var presenter: ImagesListPresenter!
    var viewControllerSpy: ImagesListViewControllerSpy!
    
    override func setUp() {
        super.setUp()
        viewControllerSpy = ImagesListViewControllerSpy()
        presenter = ImagesListPresenter(view: viewControllerSpy)
    }
    
    override func tearDown() {
        presenter = nil
        viewControllerSpy = nil
        super.tearDown()
    }
    
    func testIsShowProgressHUDCalledWithTrue() {
        // Given
        let hudValue = true
        
        // When
        viewControllerSpy.isShowProgressHUD(hudValue)
        
        // Then
        XCTAssertTrue(viewControllerSpy.isShowProgressHUDCalled)
        XCTAssertEqual(viewControllerSpy.showProgressHUDValue, hudValue)
    }
    
    func testIsShowProgressHUDCalledWithFalse() {
        // Given
        let hudValue = false
        
        // When
        viewControllerSpy.isShowProgressHUD(hudValue)
        
        // Then
        XCTAssertTrue(viewControllerSpy.isShowProgressHUDCalled)
        XCTAssertEqual(viewControllerSpy.showProgressHUDValue, hudValue)
    }
    
    func testUpdateTableViewAnimatedCalled() {
        // Given
        let indexPaths = [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)]
        
        // When
        viewControllerSpy.updateTableViewAnimated(with: indexPaths)
        
        // Then
        XCTAssertTrue(viewControllerSpy.updateTableViewAnimatedCalled)
        XCTAssertEqual(viewControllerSpy.indexPathsPassed, indexPaths)
    }
}
