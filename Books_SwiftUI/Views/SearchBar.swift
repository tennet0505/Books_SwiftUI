//
//  SearchBar.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//

import SwiftUI
import UIKit

struct SearchBarSimple: View {
    @Binding var searchText: String

    var body: some View {
        TextField("Search...", text: $searchText)
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
    }
}

struct SearchBar: UIViewControllerRepresentable {
    @Binding var text: String
    @Binding var isSearching: Bool

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        @Binding var isSearching: Bool

        init(text: Binding<String>, isSearching: Binding<Bool>) {
            _text = text
            _isSearching = isSearching
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            isSearching = true
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            text = ""
            isSearching = false
            searchBar.resignFirstResponder()
        }

        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            isSearching = false
        }

        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            isSearching = true
        }
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, isSearching: $isSearching)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search book/author"
        searchBar.searchBarStyle = .minimal
        let viewController = UIViewController()
        viewController.view = searchBar
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let searchBar = uiViewController.view as! UISearchBar
        searchBar.text = text
    }
}
