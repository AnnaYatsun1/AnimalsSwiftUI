//
//  BreedViewModel.swift
//  AnimationApp
//
//  Created by Анна Яцун on 16.01.2025.
//
import SwiftUI


@MainActor
class BreedViewModel: ObservableObject {
    @Published var breeds: [Breed] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isNetworkAvailable: Bool = true
    @Published var searchText: String = ""
    
    private var currentPage: Int = 0
    private var isLastPage: Bool = false
    private let itemsPerPage: Int = 10
    private let breedService: BreedServiceProtocol
    let networkMonitor: NetworkMonitoring
  
    var filteredBreeds: [Breed] {
        if searchText.isEmpty {
            return breeds
        } else {
            return breeds.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    // MARK: Init
    
    init(breedService: BreedServiceProtocol, networkMonitor: NetworkMonitoring) {
        self.breedService = breedService
        self.networkMonitor = networkMonitor
    }
    
    // MARK: Internal
    
    func loadMoreBreeds() async {
            guard !isLoading && !isLastPage else { return }
        let isConnected = await checkNetworkConnection()
           guard isConnected else {
               errorMessage = "No internet connection"
               return
           }
            isLoading = true
            errorMessage = nil

            do {
                let fetchedBreeds = try await breedService.fetchBreeds(page: currentPage, limit: itemsPerPage)
                if fetchedBreeds.isEmpty {
                    isLastPage = true
                } else {
                    breeds.append(contentsOf: fetchedBreeds)
                    currentPage += 1
                }
            } catch {
                errorMessage = "Failed to load breeds: \(error.localizedDescription)"
            }

            isLoading = false
        }
    
    // MARK: Private
    
    private func checkNetworkConnection() async -> Bool {
        
        for await isConnected in networkMonitor.observeNetworkChanges() {
            return isConnected
        }
        return false
    }
}
