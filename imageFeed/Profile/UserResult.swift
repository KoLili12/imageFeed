//
//  UserResult.swift
//  imageFeed
//
//  Created by Николай Жирнов on 28.01.2025.
//

import Foundation

struct UserResult: Codable {
    var profileImage: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
