//
//  ProfilePresenter.swift
//  imageFeed
//
//  Created by Николай Жирнов on 26.02.2025.
//

import Kingfisher
import UIKit

final class ProfilePresenter: ProfilePresenterProtocol {
    
    // MARK: - Internal properties
    
    weak var view: (any ProfileViewControllerProtocol)?
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    
    // MARK: - Internal functions
    
    func viewDidLoad() {
        updateProfileDetails()
        updateAvater()
    }
    
    func updateAvater() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        view?.updateAvatar(with: url)
    }
    
    func updateProfileDetails() {
        view?.updateProfileDetails(profile: profileService.profile)
    }
    
    func didTapExitButton() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Bye bye!"
        
        let yesAction = UIAlertAction(title: "Да", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            profileLogoutService.logout()
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid window configuration")
                return
            }
            window.rootViewController = SplashViewController()
        }
        
        let noAction = UIAlertAction(title: "Нет", style: .default) { _ in }
        
        yesAction.setValue("Yes", forKey: "accessibilityIdentifier")
        noAction.setValue("No", forKey: "accessibilityIdentifier")
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        view?.present(alert, animated: true, completion: nil)
    }
}
