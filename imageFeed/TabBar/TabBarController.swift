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
        guard let imagesListViewController = imagesListViewController as? ImagesListViewController else { return }
        let imagesListViewPresenter = ImagesListPresenter()
        imagesListViewPresenter.view = imagesListViewController
        imagesListViewController.presenter = imagesListViewPresenter
        
        let profileViewController = ProfileViewController()
        let profileViewpresenter = ProfilePresenter()
        profileViewpresenter.view = profileViewController
        profileViewController.presenter = profileViewpresenter
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tabEditorialActive"),
            selectedImage: nil
        )
       self.viewControllers = [imagesListViewController, profileViewController]
       }
}
