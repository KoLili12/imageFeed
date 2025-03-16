//
//  WebViewPresenter.swift
//  imageFeed
//
//  Created by Николай Жирнов on 26.02.2025.
//

import UIKit
import WebKit

final class WebViewPresenter: WebViewPresenterProtocol {
    
    // MARK: - Internal properties
    
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol?
    
    // MARK: - Init
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    // MARK: - Internal funtions
    
    func viewDidLoad() {
        guard let request = authHelper?.authRequest() else {
            return
        }
        
        didUpdateProgressValue(0)
        
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue: Float = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHiddenProgress = self.shouldHiddenProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHiddenProgress)
        
    }
    
    func shouldHiddenProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper?.code(from: url)
    }
}
