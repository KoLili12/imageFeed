//
//  ImagesListProtocol.swift
//  imageFeed
//
//  Created by Николай Жирнов on 27.02.2025.
//

import Foundation

protocol ImagesListViewProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated()
    func showErrorAlert()
    func reloadRows(at indexPaths: [IndexPath])
    func updateRow(at indexPath: IndexPath)
}
