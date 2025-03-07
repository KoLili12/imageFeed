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
        let _ = imagesListController.tableView(UITableView(), heightForRowAt: IndexPath())
        
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
        
        imagesListController.loadViewIfNeeded()
        
        let mockTableView = UITableViewMock()
        imagesListController.setValue(mockTableView, forKey: "tableView")
        
        let cell = ImagesListCell()
        let indexPath = IndexPath(row: 0, section: 0)
        mockTableView.indexPathToReturn = indexPath
        
        // When
        imagesListController.imageListCellDidTapLike(cell)
        
        // then
        XCTAssertTrue(imagesListPresenter.changeLikeStatusIsCalled)
    }
}
