    //
    //  ContentView.swift
    //  AnimationApp
    //
    //  Created by Анна Яцун on 15.01.2025.
    //

import SwiftUI


struct ContentView: View {
    private struct Constants {
        static let ok = "OK"
        static let alertConnection = "No Internet Connection"
        static let proggressInfo = "Loading breeds..."
    }
    let columns = [
        GridItem(),
        GridItem(),
    ]
    
    @StateObject private var viewModel: BreedViewModel
    @State private var showAlert = false
    
    init(viewModel: BreedViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                contentBasedOnState()
            }
            .navigationTitle("Cat Breeds")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                if viewModel.breeds.isEmpty {
                    await viewModel.loadMoreBreeds()
                }
                await observeNetworkChanges()
            }
            .onChange(of: viewModel.networkMonitor.isConnected) { isConnected in
                if !isConnected {
                    showAlert = true
                }
            }
            .alert(Constants.alertConnection, isPresented: $showAlert) {
                Button(Constants.ok, role: .cancel) {}
            }
        }
    }
    
    @ViewBuilder
    private func contentBasedOnState() -> some View {
        if !viewModel.networkMonitor.isConnected {
            Text(Constants.alertConnection)
                .foregroundColor(.red)
                .padding()
            Button("Retry") {
                Task {
                    await viewModel.loadMoreBreeds()
                }
            }
            .padding()
            .buttonStyle(.borderedProminent)
        } else if viewModel.isLoading && viewModel.breeds.isEmpty {
            ProgressView(Constants.proggressInfo)
                .padding()
        } else if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
                .foregroundColor(.red)
                .padding()
        } else {
            RefreshableScrollView(action: {
                await viewModel.loadMoreBreeds()
            }) {
                SearchBar(text: $viewModel.searchText).padding(6)
                LazyVGrid(columns: columns, spacing: 9) {
                    ForEach(viewModel.filteredBreeds) { breed in
                        NavigationLink(destination: BreedDetailView(breed: breed), label: {
                            BreedCell(breed: breed) } )
                        .onAppear {
                            if breed == viewModel.breeds.last {
                                Task {
                                    await viewModel.loadMoreBreeds()
                                }
                            }
                        }.padding()
                    }
                }
                
                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
        }
    }
    
    private func observeNetworkChanges() async {
        for await isConnected in viewModel.networkMonitor.observeNetworkChanges() {
            if isConnected {
                await viewModel.loadMoreBreeds()
            }
        }
    }
}


#Preview {
    let builder = URLBuilder(baseURL: "https://api.thecatapi.com/v1")
    let service = BreedService(urlBuilder: builder)
    let network = NetworkMonitor()
    let viewModel = BreedViewModel(breedService: service, networkMonitor: network)
    ContentView(viewModel: viewModel)
}

#Preview {
    let sampleBreed = Breed(
            id: "abys",
            name: "Abyssinian",
            description: "The Abyssinian is a playful and intelligent breed.",
            image: Breed.BreedImage(url: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg")
        )
    BreedDetailView(breed: sampleBreed)
}


