//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 02.05.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        tabBar.barTintColor = .ypBlack
        tabBar.tintColor = .ypWhite
        
        let imageListViewController = ImagesListViewController()
        
        imageListViewController.tabBarItem = UITabBarItem(title: "",
                                                          image: UIImage(named: "tab_editorial_active"),
                                                          selectedImage: nil)
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "",
                                                        image: UIImage(named: "tab_profile_active"),
                                                        selectedImage: nil)

        self.viewControllers = [imageListViewController, profileViewController]
    }
    
}



