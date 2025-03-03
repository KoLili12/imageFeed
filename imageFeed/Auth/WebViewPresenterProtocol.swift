//
//  WebViewPresenterProtocol.swift
//  imageFeed
//
//  Created by Николай Жирнов on 26.02.2025.
//

import Foundation
import WebKit

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
