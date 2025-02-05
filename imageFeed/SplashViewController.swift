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
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let imagesService = ImagesListService()
    
    private let logoImageView: UIImageView = {
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
            imagesService.fetchPhotosNextPage(token: token) { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let result):
                    print()
                }
            }
        }
        else {
            let viewController = AuthViewController()
            viewController.delegate = self
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
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
            let profileRes = errorSuccesHandling(data: result, f: "fetchProfile")
            switch profileRes {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username, token: token) { imageString in
                    let imageUrlRes = self.errorSuccesHandling(data: imageString, f: "fetchProfileImageURL")
                    switch imageUrlRes {
                    case .success(let imag):
                        print("url: \(imag)")
                    case .failure:
                        break
                    }
                }
                self.switchToTabBarController()
            case .failure:
                break
            }
        }
    }
    
    func errorSuccesHandling<T>(data: Result<T, Error>, f: String) -> Result<T, Error> {
        switch data {
        case .success(let result):
            return .success(result)
        case .failure(let error):
            switch error {
            case NetworkError.urlSessionError:
                print("сетевая ошибка [\(f)]")
            case NetworkError.httpStatusCode(let status):
                print("ошибка, которую вернул сервис Unsplash: \(status) [\(f)]")
            case NetworkError.urlRequestError(let requestError):
                print("сетевая ошибка: \(requestError) [\(f)]")
            case FetchError.invalidRequest:
                print("Ошикаб при создании URLRequest [\(f)]")
            case FetchError.invalidDecoding:
                print("ошибка, которую выкинул декодер при получении Profile [\(f)]")
            case FetchError.alreadyFetching:
                print("данные уже извлекаются [\(f)]")
            case FetchError.keyError:
                print("Ошибка извлечения ключа из UserResult.profileImage [\(f)]")
            default:
                print("неизвестная ошибка [\(f)]")
            }
            return .failure(error)
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
