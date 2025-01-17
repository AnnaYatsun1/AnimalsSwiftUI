//
//  Breed.swift
//  AnimationApp
//
//  Created by Анна Яцун on 16.01.2025.
//

struct Breed: Identifiable, Decodable, Equatable {
    let id: String
    let name: String
    let description: String
    let image: BreedImage?
    
    struct BreedImage: Decodable, Equatable {
        let url: String?
    }
}
