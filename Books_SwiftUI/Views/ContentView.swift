//
//  ContentView.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var viewModel = BooksViewModel() // Initialize the view model

       var body: some View {
           NavigationView {
               VStack(spacing: 16) {
                   if viewModel.isLoading {
                       ProgressView("Loading books...")
                   } else if let errorMessage = viewModel.errorMessage {
                       Text(errorMessage)
                           .foregroundColor(.red)
                   } else {
                       ScrollView {
                           VStack(alignment: .leading) {

                               GenreScrollView(genres: viewModel.fetchBookGenres())
                                   .frame(height: 100)

                               Text("Popular Books")
                                   .font(.title)
                                   .padding([.top, .leading])

                               BookGrid(isSmall: false, books: viewModel.popularBooks)
                               
                               Text("New Books")
                                   .font(.title)
                                   .padding([.top, .leading])

                               BookGrid(isSmall: true, books: viewModel.newBooks)
                           }
                       }
                   }
               }
               .onAppear {
                   viewModel.fetchBooks() // Fetch books when view appears
               }
               .navigationTitle("Books")
           }
       }
   }

struct GenreScrollView: View {
    let genres: [Genre]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(genres, id: \.title) { genre in
                    VStack {
                        Image(genre.image)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)
                        Text(genre.title)
                            .font(.caption)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
