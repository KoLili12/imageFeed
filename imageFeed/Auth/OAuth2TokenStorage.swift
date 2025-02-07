//
//  OAuth2TokenStorage.swift
//  imageFeed
//
//  Created by Николай Жирнов on 09.01.2025.
//

import UIKit
import SwiftKeychainWrapper
import Foundation

final class OAuth2TokenStorage {
    
    // MARK: - Private properties
    
    private let tokenKey = "BearerToken"

    // MARK: - Internal properties
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: tokenKey)
            // return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            if let newValue {
                let isSuccess = KeychainWrapper.standard.set(newValue, forKey: tokenKey)
                guard isSuccess else {
                    print("Не удалось записать токен")
                    return
                }
                // UserDefaults.standard.set(newValue, forKey: tokenKey)
            }
        }
    }
}

