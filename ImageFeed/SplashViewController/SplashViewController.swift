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
    private let profileServices = ProfileService.shared
    private let tabBarControllerID = "TabBarViewController"
    private let authViewControllerID = "AuthViewController"
    
    private let imageLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splashScreen")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Life cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        layout()
        verificationOfAuthorization()
    }
    
    //MARK: - Methods
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("[SplashViewController][switchToTabBarController]Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: tabBarControllerID)
        window.rootViewController = tabBarController
    }
    
    private func verificationOfAuthorization() {
        if let token = storage.token {
            fetchProfile(token)
        }else {
            presentAuthenticationViewController()
        }
    }
    
    private func presentAuthenticationViewController() {
        guard let authViewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(
                identifier: authViewControllerID) as? AuthViewController
        else {
            assertionFailure("[SplashViewController] [verificationOfAuthorization]Failed to instantiateViewController")
            return
        }
        authViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: authViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)

    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Что-то пошло не так, попробуйте позже",
                                                message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            self.presentAuthenticationViewController()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    private func layout() {
        view.backgroundColor = .ypBlack
        self.view.addSubview(imageLogo)
        NSLayoutConstraint.activate([
            imageLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}

//MARK: - Extension
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        dismiss(animated: true)
    }
    
    private func fetchProfile(_ token: String){
        UIBlockingProgressHUD.show()
        profileServices.fetchProfile(token: token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }

            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure(let error):
                print("[SplashViewController] [fetchProfile] Error - \(error)")
                showAlert()
            }
        }
    }
    
}
