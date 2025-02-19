//
//  Photo.swift
//  imageFeed
//
//  Created by Николай Жирнов on 05.02.2025.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
