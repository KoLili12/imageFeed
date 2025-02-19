//
//  SingleImageViewController.swift
//  imageFeed
//
//  Created by Николай Жирнов on 07.12.2024.
//

import UIKit
import Kingfisher
final class SingleImageViewController: UIViewController {
    
    // MARK: - Internal properties
    var imageURL: URL? {
        didSet {
            guard isViewLoaded, let imageURL else { return }
            downloadImage(url: imageURL)
        }
    }
//    var image: UIImage? {
//        didSet {
//            guard isViewLoaded, let image else { return }
//            imageView.image = image
//            imageView.frame.size = image.size
//            rescaleAndCenterImageInScrollView(image: image)
//        }
//    }
    
    // MARK: - @IBOutlet properties
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - @IBAction function
    
    @IBAction func didTapShareButton(_ sender: Any) {
        let shareContent = ["Sharing image"]
        let activityController = UIActivityViewController(activityItems: shareContent,
                                                          applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        guard let imageURL else { return }
        downloadImage(url: imageURL)
    }
    
    // MARK: - private function
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func downloadImage(url: URL) {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let newImage):
                self.imageView.frame.size = newImage.image.size
                self.rescaleAndCenterImageInScrollView(image: newImage.image)
                print("Картинка в SingleImageViewController загружена")
            case .failure(let error):
                self.showErrorAlert()
                print("Ошибка[SingleImageViewController]: ошибка загрузки: \(error.localizedDescription)")
            }
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так. Попробовать ещё раз",
            message: nil,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            guard let self, let imageURL = self.imageURL else { return }
            self.downloadImage(url: imageURL)
        })
        alert.addAction(UIAlertAction(title: "Не надо", style: .cancel))
        self.present(alert, animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
