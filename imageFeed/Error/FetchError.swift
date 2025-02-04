//
//  FetchError.swift
//  imageFeed
//
//  Created by Николай Жирнов on 31.01.2025.
//

import Foundation

enum FetchError: Error {
    case alreadyFetching
    case invalidRequest
    case invalidDecoding
    case keyError
}
