//
//  ProfileLogoutService.swift
//  imageFeed
//
//  Created by Николай Жирнов on 12.02.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared
    private init() {}
    
    func logout() {
        clearCookies()
        cleanData()
    }
    
    private func clearCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func cleanData() {
        storage.deleteToken()
        profileService.deleteProfile()
        profileImageService.deleteAvatarURL()
        imagesListService.deletePhotos()
    }
}
