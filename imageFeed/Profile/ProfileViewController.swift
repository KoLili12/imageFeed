//
//  ProfileViewController.swift
//  imageFeed
//
//  Created by Николай Жирнов on 05.12.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - Private properties

    private let tokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "WomanAvatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.widthAnchor.constraint(equalToConstant: 70)
            ])
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .ypWhiteIOS
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var identifierLabel: UILabel = {
        let label = UILabel()
        label.text = "@eka_novikova"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypGrayIOS
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypWhiteIOS
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let exit = exitButton()
        
        self.view.backgroundColor = .ypBlackIOS
        
        view.addSubview(avatarImage)
        view.addSubview(nameLabel)
        view.addSubview(identifierLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(exit)
        
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            avatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            identifierLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            identifierLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: identifierLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            exit.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            exit.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil, queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.updateAvater()
        }
        updateAvater()
        
        updateProfileDetails(profile: profileService.profile)
    }
    
    // MARK: - Private functions
    
    private func updateAvater() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        avatarImage.kf.setImage(with: url)
    }
    @objc private func didTapExitButton() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Да", style: .cancel) { _ in
            let profileLogoutService = ProfileLogoutService.shared
            profileLogoutService.logout()
            // Получаем экземпляр `window` приложения
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid window configuration")
                return
            }
            // Установим в `rootViewController` полученный контроллер
            window.rootViewController = SplashViewController()
        }
        
        let noAction = UIAlertAction(title: "Нет", style: .default) { _ in }

        alert.addAction(yesAction)
        alert.addAction(noAction)

        self.present(alert, animated: true, completion: nil)
    }

    
    // MARK: - Private functions
    
    private func exitButton() -> UIButton {
        let button = UIButton.systemButton(with: UIImage(named: "Exit") ?? UIImage(), target: self, action: #selector(self.didTapExitButton))
        button.tintColor = .ypRedIOS
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 44),
        ])
        return button
    }
    
    func updateProfileDetails(profile: Profile?) {
        nameLabel.text = profile?.name ?? ""
        identifierLabel.text = profile?.loginName ?? ""
        descriptionLabel.text = profile?.bio
    }
}
