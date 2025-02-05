//
//  OAuth2Service.swift
//  imageFeed
//
//  Created by Николай Жирнов on 07.01.2025.
//

import UIKit

final class OAuth2Service {
    
    // MARK: - Static properties
    
    static let shared = OAuth2Service()
    
    // MARK: - Private properties
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() {}
    
    // MARK: - Private functions
    
    private func createURLRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "\(Constants.defaultBaseURL)/oauth/token") else {
            print("Ошибка[OAuth2Service]: ошибка при создании URL")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            print("Ошибка[OAuth2Service]: ошибка при создании URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    // MARK: - Internal functions
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread, "Ошибка: Функция должна быть вызвана на главном потоке")
        guard lastCode != code else {
            print("Ошибка[OAuth2Service]: данные уже извлекаются")
            completion(.failure(FetchError.alreadyFetching))
            return
        }
        task?.cancel()
        lastCode = code
        guard let request = createURLRequest(code: code) else {
            completion(.failure(FetchError.invalidRequest))
            return
        }
        let task = URLSession.shared.objectData(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                completion(.success(data.accessToken))
            }
            self?.task = nil
            self?.lastCode = nil
        }
        self.task = task
        task.resume()
    }
}
