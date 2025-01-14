//
//  ProfileViewController.swift
//  imageFeed
//
//  Created by Николай Жирнов on 05.12.2024.
//

import UIKit

final class ProfileViewController:UIViewController {
    
    // MARK: - Private properties
    
    private let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "WomanAvatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.widthAnchor.constraint(equalToConstant: 70)
            ])
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .ypWhiteIOS
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let identifierLabel: UILabel = {
        let label = UILabel()
        label.text = "@eka_novikova"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypGrayIOS
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
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
    }
    
    // MARK: - Private functions
    
    @objc private func didTapExitButton() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Да", style: .default) { _ in
            
        }
        
        let noAction = UIAlertAction(title: "Нет", style: .cancel) { _ in
            
        }

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
}
