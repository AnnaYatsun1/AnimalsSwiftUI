//
//  String+Extension.swift
//  AnimationApp
//
//  Created by Анна Яцун on 16.01.2025.
//

extension String {
    func appendingPathComponent(_ component: String) -> String {
        let separator = "/"
        if self.hasSuffix(separator) {
            if component.hasPrefix(separator) {
                return self + component.dropFirst()
            }
            return self + component
        } else {
            if component.hasPrefix(separator) {
                return self + component
            }
            return self + separator + component
        }
    }
}
