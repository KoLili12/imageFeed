//
//  ImagesListCell.swift
//  imageFeed
//
//  Created by Николай Жирнов on 30.11.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - @IBOutlet properties
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    // MARK: - Static properties
    
    static let reuseIdentifier = "ImagesListCell"
}
