//
//  MockNetworkMonitor.swift
//  AnimationApp
//
//  Created by Анна Яцун on 16.01.2025.
//

public class MockNetworkMonitor: NetworkMonitoring {
    
    var isConnected: Bool = true
    
    private var connectionChanges: [Bool] = []
    
    func observeNetworkChanges() -> AsyncStream<Bool> {
        AsyncStream { continuation in
            for change in connectionChanges {
                continuation.yield(change)
            }
            continuation.finish()
        }
    }

    func simulateNetworkChange(_ changes: [Bool]) {
        connectionChanges = changes
    }
}

final class MockBreedService: BreedServiceProtocol {
    var result: Result<[Breed], Error> = .success([])
    
    func fetchBreeds(page: Int, limit: Int) async throws -> [Breed] {
        switch result {
        case .success(let breeds):
            return breeds
        case .failure(let error):
            throw error
        }
    }
}
