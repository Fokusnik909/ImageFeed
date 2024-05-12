//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 02.05.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let imageListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController")
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "",
                                                        image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        
        self.viewControllers = [imageListViewController, profileViewController]
    }
}


       
