//
//  SearchView.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var isSearching = false
    @EnvironmentObject var viewModel: BooksViewModel
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var filteredBooks: [Book] {
        if searchText.isEmpty {
            return viewModel.books
        } else {
            return viewModel.books.filter { book in
                book.title.localizedCaseInsensitiveContains(searchText) ||
                book.author.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 32) {
            if viewModel.isLoading {
                ProgressView("Loading books...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                VStack(alignment: .leading, spacing: 16) {
                    SearchBar(text: $searchText, isSearching: $isSearching)
                        .frame(height: 44)
                    if filteredBooks.isEmpty {
                        ContentUnavailableView.search
                    } else {
                        BookRow(books: filteredBooks)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchBooks() // Fetch books when view appears
        }
        .navigationTitle("Search")
        .onTapGestureToDismissKeyboard()
    }
}
