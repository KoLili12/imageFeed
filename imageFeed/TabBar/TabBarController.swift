//
//  TabBarController.swift
//  imageFeed
//
//  Created by Николай Жирнов on 03.02.2025.
//

import UIKit


final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tabEditorialActive"),
            selectedImage: nil
        )
       self.viewControllers = [imagesListViewController, profileViewController]
       }
}
