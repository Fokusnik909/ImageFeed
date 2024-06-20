//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Артур  Арсланов on 15.06.2024.
//

import ImageFeed
import Foundation


final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
