//
//  ImagesListTests.swift
//  image FeedTests
//
//  Created by Николай Жирнов on 28.02.2025.
//

import XCTest
@testable import imageFeed

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let imagesListController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let imagesListPresenter = ImagesListPresenterSpy()
        imagesListPresenter.view = imagesListController
        imagesListController.presenter = imagesListPresenter
        
        // when
        _ = imagesListController.view
        
        // then
        XCTAssertTrue(imagesListPresenter.fetchPhotosNextPageIsCalled)
    }
    
    func testViewControllerCallsGetPhotoHeight() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let imagesListController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let imagesListPresenter = ImagesListPresenterSpy()
        imagesListPresenter.view = imagesListController
        imagesListController.presenter = imagesListPresenter
        
        // when
        let _ = imagesListController.presenter?.getPhotoHeight(indexPath: IndexPath(), tableWidth: 1)
        
        // then
        XCTAssertTrue(imagesListPresenter.getPhotoHeightIsCalled)
        
    }
    
    func testViewControllerCallsChangeLikeStatus() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let imagesListController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let imagesListPresenter = ImagesListPresenterSpy()
        imagesListPresenter.view = imagesListController
        imagesListController.presenter = imagesListPresenter
        
        // when
        let _ = imagesListController.presenter?.changeLikeStatus(for: IndexPath(), cell: ImagesListCell())
        
        // then
        XCTAssertTrue(imagesListPresenter.changeLikeStatusIsCalled)
    }
}
