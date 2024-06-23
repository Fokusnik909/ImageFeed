//
//  ProfilePresenterTests.swift
//  ImageFeedTests
//
//  Created by Артур  Арсланов on 20.06.2024.
//

@testable import ImageFeed
import XCTest

final class ProfilePresenterTests: XCTestCase {
    
    var profilePresenter: ProfilePresenter!
    var profileViewControllerSpy: ProfileViewControllerSpy!
    
    override func setUp() {
        super.setUp()
        profileViewControllerSpy = ProfileViewControllerSpy()
        profilePresenter = ProfilePresenter(view: profileViewControllerSpy)
    }
    
    override func tearDown() {
        profilePresenter = nil
        profileViewControllerSpy = nil
        super.tearDown()
    }
    
    func testProfileImageServiceRemoveObserver() {
        // Given
        profilePresenter.profileImageServiceObserverSetting()
        
        // When
        profilePresenter.profileImageServiceRemoveObserver()
        
        // Then
        XCTAssertNil(profileViewControllerSpy.profileImageServiceObserver)
    }
    
}
