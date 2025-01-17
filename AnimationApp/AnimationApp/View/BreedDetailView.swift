//
//  BreedDetailView.swift
//  AnimationApp
//
//  Created by Анна Яцун on 16.01.2025.
//

import SwiftUI
import Kingfisher

struct BreedDetailView: View {
    let breed: Breed

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let imageUrl = breed.image?.url, let url = URL(string: imageUrl) {
                    KFImage(url)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(12)
                } else {
                    Color.gray
                        .frame(height: 200)
                        .cornerRadius(12)
                }

                Text(breed.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(breed.description)
                    .font(.body)
                    .foregroundColor(.secondary)

                Spacer()
            }
            .padding()
        }
        .navigationTitle(breed.name)
    }
}
