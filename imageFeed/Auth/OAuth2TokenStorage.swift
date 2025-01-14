//
//  OAuth2TokenStorage.swift
//  imageFeed
//
//  Created by Николай Жирнов on 09.01.2025.
//

import UIKit

import Foundation

final class OAuth2TokenStorage {
    
    // MARK: - Private properties
    
    private let tokenKey = "BearerToken"

    // MARK: - Internal properties
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
}

