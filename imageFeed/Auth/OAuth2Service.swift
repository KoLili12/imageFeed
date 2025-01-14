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
    
    private init() {}
    
    // MARK: - Private functions
    
    private func createURLRequest(code: String) -> URLRequest {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            print("Ошибка createURLRequest")
            return URLRequest(url: Constants.defaultBaseURL)
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            print("Ошибка createURLRequest")
            return URLRequest(url: Constants.defaultBaseURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    // MARK: - Internal functions
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let request = createURLRequest(code: code)
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .failure(let error):
                switch error {
                case NetworkError.urlSessionError:
                    print("сетевая ошибка")
                case NetworkError.httpStatusCode(let status):
                    print("ошибка, которую вернул сервис Unsplash: \(status)")
                case NetworkError.urlRequestError(let requestError):
                    print("сетевая ошибка: \(requestError)")
                default:
                    print("неизвестная ошибка")
                }
                completion(.failure(error))
            case .success(let data):
                do {
                    let token = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(token.accessToken))
                } catch {
                    completion(.failure(error))
                    print("ошибка, которую выкинул декодер при получении OAuthTokenResponseBody")
                }
            }
        }
        task.resume()
    }
}
