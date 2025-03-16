//
//  ViewController.swift
//  imageFeed
//
//  Created by Николай Жирнов on 23.11.2024.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController & ImagesListViewProtocol {
    
    // MARK: - Internal properties
    
    var presenter: (any ImagesListPresenterProtocol)?
    
    // MARK: - Private properties
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imagesListServiceObserver: NSObjectProtocol?
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - @IBOutlet properties
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Override properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        presenter?.fetchPhotosNextPage()
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil, queue: .main)
        { [weak self] _ in
            self?.updateTableViewAnimated()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            guard let url = presenter?.didSelectRow(at: indexPath) else { return }
            viewController.imageURL = url
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: Interanl functions
    
    func reloadRows(at indexPaths: [IndexPath]) {
        self.tableView.reloadRows(at: indexPaths, with: .automatic)
    }
    
    func updateRow(at indexPath: IndexPath) {
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    // MARK: - Private functions
    
    func updateTableViewAnimated() {
        let oldCount = tableView.numberOfRows(inSection: 0)
        let newCount = presenter?.photosCount ?? 0
        tableView.performBatchUpdates() {
            if oldCount < newCount {
                let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        presenter?.configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photosCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.tableViewWillDisplayCell(at: indexPath)
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        presenter?.getPhotoHeight(indexPath: indexPath, tableWidth: tableView.bounds.width) ?? 0
    }
}

// MARK: - ImagesListCellDelegate

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.changeLikeStatus(for: indexPath, cell: cell)
    }
}
