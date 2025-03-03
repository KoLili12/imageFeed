//
//  ProfilePresenterProtocol.swift
//  imageFeed
//
//  Created by Николай Жирнов on 26.02.2025.
//

import UIKit

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvater()
    func updateProfileDetails()
    func didTapExitButton()
}
