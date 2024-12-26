//
//  ProfileViewController.swift
//  imageFeed
//
//  Created by Николай Жирнов on 05.12.2024.
//

import UIKit

final class ProfileViewController:UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let avatar = avatarImage()
        let name = nameLabel()
        let id = identifierLabel()
        let description = descriptionLabel()
        let exit = exitButton()
        
        view.addSubview(avatar)
        view.addSubview(name)
        view.addSubview(id)
        view.addSubview(description)
        view.addSubview(exit)
        
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            avatar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            name.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 8),
            name.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            id.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            id.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            description.topAnchor.constraint(equalTo: id.bottomAnchor, constant: 8),
            description.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            exit.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            exit.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    // MARK: - Private function
    
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
    
    private func avatarImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "WomanAvatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.widthAnchor.constraint(equalToConstant: 70)
            ])
        return imageView
    }
    
    private func nameLabel() -> UILabel {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .ypWhiteIOS
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func identifierLabel() -> UILabel {
        let label = UILabel()
        label.text = "@eka_novikova"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypGrayIOS
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func descriptionLabel() -> UILabel {
        let label = UILabel()
        label.text = "Hello, world!"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypWhiteIOS
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
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
