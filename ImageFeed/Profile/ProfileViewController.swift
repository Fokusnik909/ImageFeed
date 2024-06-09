//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 04.03.2024.
//

import Foundation
import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    //MARK: - Properties
    private var avatarPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profilePhoto")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    
    private let logout: UIButton = {
        let button = UIButton.systemButton(with: UIImage(named: "Exit")! ,
                                           target: nil,
                                           action: #selector(Self.didTapLogoutButton))
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .ypWhite
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var handleName: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .ypGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subView: [UIView] = [self.avatarPhoto, self.logout, self.nameLabel, self.handleName, self.descriptionLabel]
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        updateProfileDetails()
        profileImageServiceObserverSetting()
        updateAvatar()
    }
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        profileImageServiceRemoveObserver()
    }
    
    //MARK: - Methods
    @objc private func didTapLogoutButton(){
        let profileLogoutService = ProfileLogoutService.shared
        let alertController = AlertModals.createOkCancelAlert(title: "Пока, Пока!",
                                        message: "Уверены что хотите выйти?",
                                        okButton: "Да",
                                        cancelButton: "Нет") {
            profileLogoutService.logout()
        }
        present(alertController, animated: true)
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        avatarPhoto.kf.setImage(with: url)
        
    }
    
    private func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        self.nameLabel.text = profile.name
        self.handleName.text = profile.login
        self.descriptionLabel.text = profile.bio
    }
    
    private func layout() {
        view.backgroundColor = .ypBlack
        for view in subView { self.view.addSubview(view)}
        
        NSLayoutConstraint.activate([
            avatarPhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            avatarPhoto.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            avatarPhoto.heightAnchor.constraint(equalToConstant: 70),
            avatarPhoto.widthAnchor.constraint(equalToConstant: 70),
            
            logout.centerYAnchor.constraint(equalTo: avatarPhoto.centerYAnchor),
            logout.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            
            nameLabel.topAnchor.constraint(equalTo: avatarPhoto.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarPhoto.leadingAnchor),
            
            handleName.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            handleName.leadingAnchor.constraint(equalTo: avatarPhoto.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: handleName.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarPhoto.leadingAnchor)
        ])
    }
    
    //MARK: - Observer Method
    private func profileImageServiceObserverSetting() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }
    
    private func profileImageServiceRemoveObserver() {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
}
