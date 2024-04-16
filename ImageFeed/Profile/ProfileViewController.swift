//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 04.03.2024.
//

import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK: - Properties
    
    private var avatarPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profilePhoto")
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
    }
    
    //MARK: - Methods
    
    @objc private func didTapLogoutButton(){
        print("logout")
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

}
