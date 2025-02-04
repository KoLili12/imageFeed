//
//  ProfileImageService.swift
//  imageFeed
//
//  Created by Николай Жирнов on 28.01.2025.
//

import Foundation

final class ProfileImageService {
    // MARK: - Static properties
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    
    // MARK: - Private properties
    
    private var lastUsername: String?
    private var lastToken: String?
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Functions
    
    func createURLRequest(username: String, authToken: String) -> URLRequest? {
        guard let urlComponents = URLComponents(string: "https://api.unsplash.com/users/\(username)"),
              let url = urlComponents.url
        else {
            print("ошибка при создании URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfileImageURL(username: String, token: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread, "Ошибка: Функция должна быть вызвана на главном потоке")
        guard lastUsername != username,
              lastToken != token
        else {
            completion(.failure(FetchError.alreadyFetching))
            return
        }
        task?.cancel()
        
        lastUsername = username
        lastToken = token
        
        guard let request = createURLRequest(username: username, authToken: token) else {
            completion(.failure(FetchError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectData(for: request) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                guard let profileImageURL = data.profileImage["small"] else {
                    completion(.failure(FetchError.keyError))
                    return
                }
                self?.avatarURL = profileImageURL
                completion(.success(profileImageURL))
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": profileImageURL]
                )
            }
            self?.task = nil
            self?.lastUsername = nil
            self?.lastToken = nil
        }
        self.task = task
        task.resume()
    }
}

