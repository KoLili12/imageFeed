//
//  ProfileViewProtocol.swift
//  imageFeed
//
//  Created by Николай Жирнов on 26.02.2025.
//

import UIKit

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar(with url: URL?)
    func updateProfileDetails(profile: Profile?)
    func didTapExitButton()
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}
