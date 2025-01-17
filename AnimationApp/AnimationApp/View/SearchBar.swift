//
//  SearchBar.swift
//  AnimationApp
//
//  Created by Анна Яцун on 16.01.2025.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search..."
        searchBar.backgroundImage = UIImage()
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.searchTextField.leftView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchBar.searchTextField.leftViewMode = .always
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
        updateSearchIconVisibility(uiView)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func updateSearchIconVisibility(_ searchBar: UISearchBar) {
        if let leftView = searchBar.searchTextField.leftView as? UIImageView {
            leftView.isHidden = !text.isEmpty
        }
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        var parent: SearchBar

        init(_ parent: SearchBar) {
            self.parent = parent
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            parent.text = searchText
        }
    }
}
