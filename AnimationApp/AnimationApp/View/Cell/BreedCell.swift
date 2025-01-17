//
//  BreedCell.swift
//  AnimationApp
//
//  Created by Анна Яцун on 16.01.2025.
//

import SwiftUI
import Kingfisher

struct BreedCell: View {
    let breed: Breed

    var body: some View {
        VStack {
            if let imageUrl = breed.image?.url, let url = URL(string: imageUrl) {
                KFImage(url)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipped()
                    .cornerRadius(25)
                    .shadow(color: .gray.opacity(0.5), radius: 4, x: 2, y: 2)
            } else {
                Color.gray
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
            }
            Text(breed.name)
                .font(.custom("HelveticaNeue-Bold", size: 18))
                .lineLimit(1)
                .fixedSize()
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
        }
        .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
            .padding(.horizontal)
    }
}
