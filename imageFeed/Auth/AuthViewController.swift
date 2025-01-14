//
//  AuthViewController.swift
//  imageFeed
//
//  Created by Николай Жирнов on 29.12.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let oauth2Service = OAuth2Service.shared
    private let tokenStorage = OAuth2TokenStorage()
    
    // MARK: - Internal properties
    
    weak var delegate: AuthViewControllerDelegate?
    let idSegue = "ShowWebView"
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == idSegue {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(idSegue)")
                return
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private functions
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Backward")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black (IOS)")
    }
}

// MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            switch result {
            case .failure(let error):
                switch error {
                case NetworkError.urlSessionError:
                    print("сетевая ошибка")
                case NetworkError.httpStatusCode(let status):
                    print("ошибка, которую вернул сервис Unsplash: \(status)")
                case NetworkError.urlRequestError(let requestError):
                    print("сетевая ошибка: \(requestError)")
                default:
                    print("неизвестная ошибка")
                }
            case .success(let data):
                guard let self = self else { return }
                self.delegate?.didAuthenticate(self)
                self.tokenStorage.token = data
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        // self.navigationController?.popViewController(animated: true)
        vc.dismiss(animated: true)
    }
}
