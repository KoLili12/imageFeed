//
//  ImagesListService.swift
//  imageFeed
//
//  Created by Николай Жирнов on 05.02.2025.
//

import UIKit

final class ImagesListService {
    
    var task: URLSessionTask?
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    func fetchPhotosNextPage(token: String, completion: @escaping (Result<[PhotoResult], Error>) -> Void) {
        assert(Thread.isMainThread, "Ошибка: Функция должна быть вызвана на главном потоке")
        if task != nil {
            completion(.failure(FetchError.alreadyFetching))
            return
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        self.lastLoadedPage = nextPage
        
        guard let request = createURLRequest(authToken: token, page: nextPage) else {
            completion(.failure(FetchError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectData(for: request) { (result: Result<[PhotoResult], Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let photoResults):
                for item in photoResults {
                    let photo = Photo(id: item.id,
                                      size: CGSize(width: item.width, height: item.height),
                                      createdAt: Date.from(dateTimeString: item.createdAt),
                                      welcomeDescription: item.description, thumImageURL: item.urls.small, largeImageURL: item.urls.regular, isLiked: false
                                      )
                }
                completion(.success(photoResults))
            }
        }
        self.task = task
        task.resume()
    }
    
    
    func createURLRequest(authToken: String, page: Int) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://api.unsplash.com/photos") else {
            print("Ошибка createURLRequest")
            return nil
        }
        
        urlComponents.queryItems =
        [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: "10")
        ]
        
        guard let url = urlComponents.url else {
            print("Ошибка createURLRequest")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
                                            
}

