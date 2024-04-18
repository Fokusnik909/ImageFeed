//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 17.04.2024.
//

import Foundation
import UIKit

final class SplashViewController: UIViewController {
    
    private let storage = OAuth2TokenStorage()
    private let showAuthenticationScreenSegueIdentifier = "showAuthenticationScreenSegueIdentifier"
    private let tabBarControllerID = "TabBarViewController"
    
    //MARK: - Life cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        verificationOfAuthorization()
    }
    
    //MARK: - Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard let navigationController = segue.destination as? UINavigationController,
                  let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: tabBarControllerID)
        window.rootViewController = tabBarController
    }
    
    private func verificationOfAuthorization() {
        if storage.token != nil {
            switchToTabBarController()
        }else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
}

//MARK: - Extension
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        dismiss(animated: true)
    }
}
