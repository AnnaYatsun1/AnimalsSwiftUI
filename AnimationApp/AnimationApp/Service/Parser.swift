//
//  Parser.swift
//  AnimationApp
//
//  Created by Анна Яцун on 16.01.2025.
//

import Foundation

enum ParserErrors: Error {
    case dataError
}

class Parser<Object: Decodable> {
    
    func object(from data: Data) -> Result<Object, Error> {
        guard let model = try? JSONDecoder()
            .decode(Object.self,
                    from: data
            ) else {
                return .failure(ParserErrors.dataError)
            }
        return .success(model)
    }
}
