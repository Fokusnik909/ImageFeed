//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 10.04.2024.
//

import Foundation
import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    //MARK: - Properties
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    weak var delegate: AuthViewControllerDelegate?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    //MARK: - Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                fatalError("Failed to prepare for \(showWebViewSegueIdentifier)")
            }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        }
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Backward")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
    
    private func showAlert(error: Error) {
        let alertController = AlertModals.createOkAlert(
            title: "Что-то пошло не так =(",
            message: "Не удалось войти в систему - \(error)",
            okButton: "OK") { [weak self]  in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            }
        // Check if the view controller is currently presented
        if self.presentedViewController == nil {
            present(alertController, animated: true, completion: nil)
        } else {
            // If already presenting another view controller, present the alert after dismissing it
            dismiss(animated: true) {
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    
}

//MARK: - Extension
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.oauth2TokenStorage.token = token
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                showAlert(error: error)
                print(error)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
}
