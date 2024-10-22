//
//  MyLibraryView.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//

import SwiftUI

struct MyLibraryView: View {
    @State private var searchText = ""
    @StateObject private var viewModel = BooksViewModel() // Initialize the view model
    
    let columns = [
        GridItem(.flexible()),
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
        NavigationView {
            VStack(spacing: 32) {
                if viewModel.isLoading {
                    ProgressView("Loading books...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    VStack(spacing: 16) {
                        SearchBar(searchText: $searchText)
                        BookGrid(books: filteredBooks)
                    }
                }
            }
            .onAppear {
                viewModel.fetchBooks() // Fetch books when view appears
            }
            .navigationTitle("My library")
        }
    }
}