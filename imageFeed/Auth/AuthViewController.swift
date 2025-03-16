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
                showErrorAlert()
                assertionFailure("Failed to prepare for \(idSegue)")
                return
            }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
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
    
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

// MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        
        UIBlockingProgressHUD.show()
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .failure(let error):
                print("Ошибка[AuthViewController] получения токена: \(error)")
                showErrorAlert()
            case .success(let data):
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
