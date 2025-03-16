//
//  AuthHelperProtocol.swift
//  imageFeed
//
//  Created by Николай Жирнов on 26.02.2025.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}
