//
//  ProfileViewController.swift
//  imageFeed
//
//  Created by Николай Жирнов on 05.12.2024.
//

import UIKit

final class ProfileViewController:UIViewController {
    
    // MARK: - @IBOutlet properties
    
    @IBOutlet private var nameLabel: UILabel!
    
    @IBOutlet private var loginNameLabel: UILabel!
    
    @IBOutlet private var logoutButton: UIButton!
    
    @IBOutlet private var descriptionLabel: UILabel!
    
    // MARK: - @IBAction properties
    
    @IBAction private func didTapLogoutButton(_ sender: Any) {
    }
}
