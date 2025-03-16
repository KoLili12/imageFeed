//
//  ImagesListPresenterProtocol.swift
//  imageFeed
//
//  Created by Николай Жирнов on 27.02.2025.
//

import Foundation

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewProtocol? { get set }
    var photos: [Photo] { get }
    var photosCount: Int { get }
    func fetchPhotosNextPage()
    
    func didSelectRow(at indexPath: IndexPath) -> URL?
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
    func getPhotoHeight(indexPath: IndexPath, tableWidth: CGFloat) -> CGFloat
    func changeLikeStatus(for indexPath: IndexPath, cell: ImagesListCell)
    func tableViewWillDisplayCell(at indexPath: IndexPath)
}
