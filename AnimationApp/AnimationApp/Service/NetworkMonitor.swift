//
//  NetworkMonitor.swift
//  AnimationApp
//
//  Created by Анна Яцун on 16.01.2025.
//

import Foundation
import Network

protocol NetworkMonitoring {
    var isConnected: Bool { get }
    func observeNetworkChanges() -> AsyncStream<Bool>
}


class NetworkMonitor: ObservableObject, NetworkMonitoring {
    @Published private(set) var isConnected: Bool = true
    
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private var continuation: AsyncStream<Bool>.Continuation?

    // MARK: Init
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.updateConnectionStatus(path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }

    // MARK: Internal
    
    func observeNetworkChanges() -> AsyncStream<Bool> {
        AsyncStream { continuation in
            self.continuation = continuation
            continuation.yield(isConnected)

            continuation.onTermination = { [weak self] _ in
                self?.continuation = nil
            }
        }
    }
    
    // MARK: Private
    
    private func updateConnectionStatus(_ status: Bool) {
        Task { @MainActor in
            self.isConnected = status
            continuation?.yield(status)
        }
    }
}
