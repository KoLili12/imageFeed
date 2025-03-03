//
//  ProfilePresenterSpy.swift
//  image FeedTests
//
//  Created by Николай Жирнов on 28.02.2025.
//

import UIKit
@testable import imageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    // MARK: - Internal properties
    
    var view: (any imageFeed.ProfileViewControllerProtocol)?
    
    var viewDidLoadIsCalled = false
    var didTapExitButtonIsCalled = false
    
    // MARK: - Internal functions
    
    func viewDidLoad() {
        viewDidLoadIsCalled = true
    }
    
    func updateAvater() {
        
    }
    
    func updateProfileDetails() {
        
    }
    
    func didTapExitButton() {
        didTapExitButtonIsCalled = true
    }
    
    
}
