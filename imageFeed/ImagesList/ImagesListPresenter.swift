//
//  ImagesListPresenter.swift
//  imageFeed
//
//  Created by Николай Жирнов on 27.02.2025.
//

import UIKit
import Kingfisher

final class ImagesListPresenter: @preconcurrency ImagesListPresenterProtocol {
    
    // MARK: - Internal properties
    var photos: [Photo] {
        imagesListService.photos
    }
    var photosCount: Int {
        photos.count
    }
    weak var view: (any ImagesListViewProtocol)?
    
    // MARK: - Private properties
    
    private var imagesListService = ImagesListService.shared
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    // MARK: Interanl functions
    
    func didSelectRow(at indexPath: IndexPath) -> URL? {
        let photo = photos[indexPath.row]
        let url = URL(string: photo.largeImageURL)
        return url
    }
    
    @MainActor func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.delegate = view as? any ImagesListCellDelegate
        cell.selectionStyle = .none
        guard let mockPhoto = UIImage(named: "MockPicture") else { return }
        guard let newPhotoURL = URL(string: imagesListService.photos[indexPath.row].thumImageURL) else { return }
        cell.cellImage?.kf.indicatorType = .activity
        cell.cellImage?.kf.setImage(with: newPhotoURL, placeholder: mockPhoto) { [weak self] result in
            switch result {
            case .success:
                self?.view?.reloadRows(at: [indexPath])
            case .failure(let error):
                print("Ошибка[ImagesListService]: ошибка загрузки: \(error.localizedDescription)")
            }
        }
        cell.dateLabel?.text = photos[indexPath.row].createdAt?.toRussianFormat() ?? ""
        let likeImage = photos[indexPath.row].isLiked ? UIImage(named: "ActiveLike") : UIImage(named: "InactiveLike")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
    
    func getPhotoHeight(indexPath: IndexPath, tableWidth: CGFloat) -> CGFloat {
        let photo = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableWidth - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func changeLikeStatus(for indexPath: IndexPath, cell: ImagesListCell) {
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                cell.setIsLiked(photo.isLiked)
                view?.updateRow(at: indexPath)
                print("Поставлен/убран лайк")
            case .failure(let error):
                view?.showErrorAlert()
                print("Ошибка[ImagesListService]: ошибка проставления лайка: \(error.localizedDescription)")
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func tableViewWillDisplayCell(at indexPath: IndexPath) {
        if indexPath.row == photosCount - 1 {
            fetchPhotosNextPage()
        }
    }
    
}
