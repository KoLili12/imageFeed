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
    
    // MARK: - Private properties
    
    private let isLiked: Bool = false
    
    // MARK: - Internal properties
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBAction func didTapLikeButton(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    
    // MARK: - Static properties
    
    static let reuseIdentifier = "ImagesListCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    // MARK: - Internal properties
    
    func setIsLiked(_ isLiked: Bool) {
        let image = isLiked ? UIImage(named: "ActiveLike") :  UIImage(named: "InactiveLike")
        likeButton.setImage(image, for: .normal)
    }
}
