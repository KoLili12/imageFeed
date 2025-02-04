//
//  ProfileService.swift
//  imageFeed
//
//  Created by Николай Жирнов on 19.01.2025.
//

import UIKit


struct Profile {
    var username: String
    var name: String
    var loginName: String
    var bio: String
    
}

final class ProfileService {
    
    // MARK: - Static properties
    
    static let shared = ProfileService()
    
    // MARK: - Private properties
    
    private var task: URLSessionTask?
    private var lastToken: String?
    private(set) var profile: Profile?
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Functions
    
    private func createURLRequest(authToken: String) -> URLRequest? {
        guard let urlComponents = URLComponents(string: "https://api.unsplash.com/me") else {
            print("Ошибка createURLRequest")
            return nil
        }
        
        guard let requestURL = urlComponents.url else {
            print("Ошибка createURLRequest")
            return nil
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread, "Ошибка: Функция должна быть вызвана на главном потоке")
        guard lastToken != token else {
            completion(.failure(FetchError.alreadyFetching))
            return
        }
        task?.cancel()
        lastToken = token
        guard let request = createURLRequest(authToken: token) else {
            completion(.failure(FetchError.invalidRequest))
            return
        }
        let task = URLSession.shared.objectData(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                let profile = Profile(
                    username:  data.username,
                    name:  data.firstName + " " + data.lastName,
                    loginName:  "@\(data.username)",
                    bio: data.bio ?? ""
                )
                self?.profile = profile
                completion(.success(profile))
            }
            self?.task = nil
            self?.lastToken = nil
        }
        self.task = task
        task.resume()
    }
}
