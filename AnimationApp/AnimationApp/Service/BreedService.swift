//
//  BreedService.swift
//  AnimationApp
//
//  Created by Анна Яцун on 16.01.2025.
//
import Foundation

enum BreedServiceError: Error {
    case invalidURL
    case decodingError
    case networkError(Error)
}

protocol BreedServiceProtocol: AnyObject {
    @MainActor
    func fetchBreeds(page: Int, limit: Int) async throws -> [Breed]
}

class BreedService: BreedServiceProtocol {
    private struct APIConstants {
        static let apiKey = "live_2xAkiAZOk9WWjp6rWQz6LfQEyoOL1LVXFuxC84EGZNGshrqCq49LgmlzP1tLVFJb"
        static let limit = "limit"
        static let page = "page"
    }
    
    private let parser = Parser<[Breed]>()
    private let session: URLSession
    private let urlBuilder: URLBuilder
    
    // MARK: Init
    
    init(session: URLSession = .shared, urlBuilder: URLBuilder) {
        self.session = session
        self.urlBuilder = urlBuilder
    }
    
    // MARK: Internal
    
    @MainActor
    func fetchBreeds(page: Int, limit: Int) async throws -> [Breed] {
        let request = try urlBuilder
            .setPath("/breeds")
            .addQueryItem(name: APIConstants.limit, value: "\(limit)")
            .addQueryItem(name: APIConstants.page, value: "\(page)")
            .addHeader(name: "x-api-key", value: APIConstants.apiKey)
            .build()
        
        let (data, _) = try await session.data(for: request)
        
        switch parser.object(from: data) { 
        case .success(let breeds):
            return breeds
        case .failure(let error):
            throw error
        }
    }
}
