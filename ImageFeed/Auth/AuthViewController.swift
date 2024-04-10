//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 10.04.2024.
//

import Foundation
import UIKit


final class AuthViewController: UIViewController {
    //MARK: - Properties
    private let showWebView = "ShowWebView"

    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    //MARK: - Methods
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Backward")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
}
