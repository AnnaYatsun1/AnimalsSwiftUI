//
//  URLBuilder.swift
//  AnimationApp
//
//  Created by Анна Яцун on 16.01.2025.
//

import Foundation

class URLBuilder {
    private let baseURL: String
    private var path: String = ""
    private var queryItems: [URLQueryItem] = []
    private var headers: [String: String] = [:]

    // MARK: Init
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }

    // MARK: Internal
    
    func setPath(_ path: String) -> URLBuilder {
        self.path = path
        return self
    }

    func addQueryItem(name: String, value: String) -> URLBuilder {
        queryItems.append(URLQueryItem(name: name, value: value))
        return self
    }

    func addHeader(name: String, value: String) -> URLBuilder {
        headers[name] = value
        return self
    }

    func build() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw BreedServiceError.invalidURL
        }
        urlComponents.path = urlComponents.path.appendingPathComponent(path)
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            throw BreedServiceError.invalidURL
        }

        var request = URLRequest(url: url)
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        return request
    }
}
