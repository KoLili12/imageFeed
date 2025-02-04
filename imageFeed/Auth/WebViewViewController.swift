//
//  WebViewViewController.swift
//  imageFeed
//
//  Created by Николай Жирнов on 30.12.2024.
//

import UIKit
@preconcurrency import WebKit

final class WebViewViewController: UIViewController {
    
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
        loadAuthView()
        
        progressView.setProgress(0.1, animated: false)
        progressView.progressViewStyle = .bar
        
        estimatedProgessObservation = webView.observe(\.estimatedProgress, options: []) { [weak self]  _, _ in
            self?.updateProgress()
        }
    }
    
    // MARK: - Private functions

    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString) else {
            print("Ошибка loadAuthView")
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]

        guard let url = urlComponents.url else {
            print("Ошибка loadAuthView")
            return
        }

        let request = URLRequest(url: url)
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
         if let code = code(from: navigationAction) {
             self.delegate?.webViewViewController(self, didAuthenticateWithCode: code)
             decisionHandler(.cancel)
          } else {
              decisionHandler(.allow)
            }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value                                           
        } else {
            return nil
        }
    }
}
