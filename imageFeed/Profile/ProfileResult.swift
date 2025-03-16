//
//  ProfileResult.swift
//  imageFeed
//
//  Created by Николай Жирнов on 19.01.2025.
//

import UIKit

struct ProfileResult: Decodable {
    var username: String?
    var firstName: String?
    var lastName: String?
    var bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}
