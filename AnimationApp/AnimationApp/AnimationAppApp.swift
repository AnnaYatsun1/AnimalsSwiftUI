//
//  AnimationAppApp.swift
//  AnimationApp
//
//  Created by Анна Яцун on 15.01.2025.
//

import SwiftUI

@main
struct AnimationAppApp: App {
    @State private var showLaunchScreen = true
    
    var body: some Scene {
        WindowGroup {
            if showLaunchScreen {
                LaunchScreenView()
                    .onAppear {
                        withAnimation {
                            showLaunchScreen = false
                        }
                    }
            } else {
                let builder = URLBuilder(baseURL: "https://api.thecatapi.com/v1")
                let service = BreedService(urlBuilder: builder)
                let network = NetworkMonitor()
                let viewModel = BreedViewModel(breedService: service
                                               , networkMonitor: network)
                ContentView(viewModel: viewModel).onAppear {
                    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified
                }
            }
        }
    }
}


struct LaunchScreenView: View {
    @State private var backgroundColor = Color.blue
    @State private var scale: CGFloat = 0.5
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(
                        .easeInOut(duration: 100)
                        .repeatForever(autoreverses: true)
                    ) {
                        backgroundColor = Color.purple
                    }
                }
            VStack {
                Image("cat")
                    .resizable()
                    .rotationEffect(.degrees(rotation))
                    .onAppear {
                        withAnimation(
                            .easeInOut(duration: 2)
                            .repeatForever(autoreverses: true)
                        ) {
                            scale = 1.0
                            rotation = 360
                        }
                    }
                
                Text("Breed Info")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .opacity(scale)
                    .onAppear {
                        withAnimation(
                            .easeInOut(duration: 2)
                            .repeatForever(autoreverses: true)
                        ) {
                            scale = 1.0
                        }
                    }
            }
        }
    }
}
