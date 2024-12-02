//
//  ImagesListCell.swift
//  imageFeed
//
//  Created by Николай Жирнов on 30.11.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet var cellImage: UIImageView!
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var likeButton: UIButton!
    
    static let reuseIdentifier = "ImagesListCell"
}
