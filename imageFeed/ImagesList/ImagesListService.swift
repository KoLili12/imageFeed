//
//  ImagesListService.swift
//  imageFeed
//
//  Created by Николай Жирнов on 05.02.2025.
//

import UIKit

final class ImagesListService {
    
    static let shared = ImagesListService()
    
    private var task: URLSessionTask?
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let storage = OAuth2TokenStorage()
    
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    private init() {}
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread, "Ошибка: Функция должна быть вызвана на главном потоке")
        if task != nil {
            print("Ошибка[ProfileService]: данные уже извлекаются")
            return
        }
        task?.cancel()
        guard let request = createURLRequest() else {
            return
        }
        let task = URLSession.shared.objectData(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .failure(let error):
                print("error: \(error)")
            case .success(let photoResults):
                for item in photoResults {
                    let photo = Photo(
                        id: item.id,
                        size: CGSize(width: item.width, height: item.height),
                        createdAt: Date.from(dateTimeString: item.createdAt),
                        welcomeDescription: item.description,
                        thumImageURL: item.urls.small,
                        largeImageURL: item.urls.full,
                        isLiked: item.likedByUser
                    )
                    self?.photos.append(photo)
                    print("Фото с сервера: \(photoResults.map { "\($0.id) - Лайк: \($0.likedByUser)" })")
                }
            }
            NotificationCenter.default.post(
                name: ImagesListService.didChangeNotification,
                object: self
            )
            self?.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let request = createURLRequest(id: photoId, isLike: isLike) else {
            return
        }
        
        let task = URLSession.shared.objectData(for: request) { [weak self] (result: Result<PhotoLikeResponse, Error>) in
            guard let self else { return }
            switch  result {
            case .failure(let error):
                print("error: \(error)")
                completion(.failure(error))
            case .success(let response):
                let responsePhoto = response.photo
                if let index = self.photos.firstIndex(where: { $0.id == responsePhoto.id }) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumImageURL: photo.thumImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked
                    )
                    self.photos[index] = newPhoto
                    completion(.success(()))
                }
            }
        }
        task.resume()
    }
    
    
    private func createURLRequest() -> URLRequest? {
        guard var urlComponents = URLComponents(string: "\(Constants.defaultBaseURL)/photos") else {
            print("Ошибка[ImagesListService]: ошибка при создании URL")
            return nil
        }
        let nextPage = (lastLoadedPage ?? 0) + 1
        lastLoadedPage = nextPage
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(nextPage)),
            URLQueryItem(name: "per_page", value: "10")
        ]
        guard let url = urlComponents.url else {
            print("Ошибка[ImagesListService]: ошибка при создании URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let token = storage.token else {
            print("error")
            return nil
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func createURLRequest(id: String, isLike: Bool) -> URLRequest? {
        guard let urlComponents = URLComponents(string: "\(Constants.defaultBaseURL)/photos/\(id)/like") else {
            print("Ошибка[ImagesListService]: ошибка при создании URL")
            return nil
        }
        guard let url = urlComponents.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        guard let token = storage.token else {
            print("error")
            return nil
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func deletePhotos() {
        photos.removeAll()
        lastLoadedPage = nil
    }
                                            
}

