//
//  ImagesListPresenter.swift
//  image FeedTests
//
//  Created by Николай Жирнов on 28.02.2025.
//

import UIKit
@testable import imageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    
    // MARK: - Internal properties
    
    var view: (any imageFeed.ImagesListViewProtocol)?
    var fetchPhotosNextPageIsCalled = false
    var getPhotoHeightIsCalled = false
    var changeLikeStatusIsCalled = false
    
    var photos: [imageFeed.Photo] = []
    
    var photosCount: Int = 0
    
    // MARK: - Internal functions
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageIsCalled = true
    }
    
    func didSelectRow(at indexPath: IndexPath) -> URL? {
        return nil
    }
    
    func configCell(for cell: imageFeed.ImagesListCell, with indexPath: IndexPath) {
        
    }
    
    func getPhotoHeight(indexPath: IndexPath, tableWidth: CGFloat) -> CGFloat {
        getPhotoHeightIsCalled = true
        return CGFloat.zero
    }
    
    func changeLikeStatus(for indexPath: IndexPath, cell: imageFeed.ImagesListCell) {
        changeLikeStatusIsCalled = true
    }
    
    func tableViewWillDisplayCell(at indexPath: IndexPath) {
        
    }
    
    
}
