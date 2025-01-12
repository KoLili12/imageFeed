//
//  WebViewViewControllerDelegate.swift
//  imageFeed
//
//  Created by Николай Жирнов on 03.01.2025.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
