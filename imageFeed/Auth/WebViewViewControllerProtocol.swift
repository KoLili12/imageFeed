//
//  WebViewViewControllerProtocol.swift
//  imageFeed
//
//  Created by Николай Жирнов on 26.02.2025.
//
import Foundation

protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}
