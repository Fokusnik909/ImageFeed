//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 04.03.2024.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarPhoto: UIImageView!
    @IBOutlet weak var logOut: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var handleLogin: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    @IBAction func didTapLogoutButton(_ sender: UIButton) {
    }
}
