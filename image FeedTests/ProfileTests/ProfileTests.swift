//
//  ProfileTests.swift
//  image FeedTests
//
//  Created by Николай Жирнов on 27.02.2025.
//

import XCTest
@testable import imageFeed

final class ProfileTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        // given
        let profilePresenter = ProfilePresenterSpy()
        let profileController = ProfileViewController()
        profilePresenter.view = profileController
        profileController.presenter = profilePresenter
        
        // when
        _ = profileController.view
        
        // then
        XCTAssertTrue(profilePresenter.viewDidLoadIsCalled)
    }
    
    func testViewControllerCallsDidTapExitButton() {
        // given
        let profilePresenter = ProfilePresenterSpy()
        let profileController = ProfileViewController()
        profilePresenter.view = profileController
        profileController.presenter = profilePresenter
        
        // when
        profileController.didTapExitButton()
        
        // then
        XCTAssertTrue(profilePresenter.didTapExitButtonIsCalled)
    }
}
