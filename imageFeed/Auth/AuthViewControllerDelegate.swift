//
//  AuthViewControllerDelegate.swift
//  imageFeed
//
//  Created by Николай Жирнов on 10.01.2025.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
