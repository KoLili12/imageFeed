//
//  WebViewViewControllerSpy.swift
//  image FeedTests
//
//  Created by Николай Жирнов on 26.02.2025.
//

import Foundation
@testable import imageFeed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: imageFeed.WebViewPresenterProtocol?
    var loadIsCalled: Bool = false
    
    func load(request: URLRequest) {
        loadIsCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
    
}
