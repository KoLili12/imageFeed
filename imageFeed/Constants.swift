//
//  Constants.swift
//  imageFeed
//
//  Created by Николай Жирнов on 26.12.2024.
//

import Foundation

enum Constants {
    static let accessKey = "39xx2N1NB_GcvTFkQ3RDVCd7tmS9Z5nXXYvcRSsBGq8"
    static let secretKey = "Yee2HHDkz1mEAi3yQntFcGSkvGgw7fgLfqCfHQjz6iQ"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
