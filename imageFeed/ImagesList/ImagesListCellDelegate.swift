//
//  ImagesListCellDelegate.swift
//  imageFeed
//
//  Created by Николай Жирнов on 11.02.2025.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
