//
//  WebViewViewController.swift
//  imageFeed
//
//  Created by Николай Жирнов on 30.12.2024.
//

import UIKit
@preconcurrency import WebKit

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    var presenter: (any WebViewPresenterProtocol)?
    
    
    private var estimatedProgessObservation: NSKeyValueObservation?
    
    // MARK: - Internal properties
    
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: - @IBOutlet properties
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.accessibilityIdentifier = "UnsplashWebView"
        presenter?.viewDidLoad()
        
        progressView.setProgress(0.1, animated: false)
        progressView.progressViewStyle = .bar
        
        estimatedProgessObservation = webView.observe(\.estimatedProgress, options: []) { [weak self]  _, _ in
            guard let self else { return }
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        }
    }
    
    // MARK: - Internal functions
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ newValue: Bool) {
        progressView.isHidden = newValue
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
}

// MARK: - WKNavigationDelegate

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let url = navigationAction.request.url,
           let code = presenter?.code(from: url)
        {
            self.delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
