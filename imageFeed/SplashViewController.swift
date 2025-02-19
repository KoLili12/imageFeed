//
//  SplashViewController.swift
//  imageFeed
//
//  Created by Николай Жирнов on 10.01.2025.
//

import UIKit

class SplashViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let showAuthenticationScreenSegueIdentifier = "showAuthenticationScreen"
    private let showAuthViewControllerIdentifier = "AuthViewController"
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "launchScreenLogo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlackIOS
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = storage.token {
            fetchProfile(token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            if let viewController = storyboard.instantiateViewController(withIdentifier: showAuthViewControllerIdentifier) as? AuthViewController {
                viewController.delegate = self
                viewController.modalPresentationStyle = .fullScreen
                present(viewController, animated: true)
            }
        }
    }
    
    // MARK: - Private functions
    
    private func switchToTabBarController() {
        // Получаем экземпляр `window` приложения
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        // Создаём экземпляр нужного контроллера из Storyboard с помощью ранее заданного идентификатора
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        // Установим в `rootViewController` полученный контроллер
        window.rootViewController = tabBarController
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username, token: token) { imageString in
                    switch imageString {
                    case .success(let image):
                        print("url: \(image)")
                    case .failure(let error):
                        print("Ошибка[SplashViewController]: \(error)")
                    }
                }
                self.switchToTabBarController()
            case .failure:
                break
            }
        }
    }
}

// MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        guard let token = storage.token else {
            return
        }
        fetchProfile(token)
    }
}
