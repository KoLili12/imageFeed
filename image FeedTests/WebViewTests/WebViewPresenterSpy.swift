//
//  WebViewPresenterSpy.swift
//  image FeedTests
//
//  Created by Николай Жирнов on 26.02.2025.
//

@testable import imageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    
    // MARK: - Internal properties
    
    var viewLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    // MARK: - Internal functions
    
    func viewDidLoad() {
        viewLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
    
}
