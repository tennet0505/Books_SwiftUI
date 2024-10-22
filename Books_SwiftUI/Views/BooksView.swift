//
//  BooksView.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//

import SwiftUI

struct BooksView: View {
    
    @State private var searchText = ""
    @StateObject private var viewModel = BooksViewModel() 
    @EnvironmentObject var tabViewModel: TabViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                if viewModel.isLoading {
                    ProgressView("Loading books...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    ScrollView {
                        ZStack {
                            SearchBar(searchText: $searchText)
                                .disabled(true)
                            Button(action: {
                                tabViewModel.selectedTab = 2
                            }) {
                                Text("")
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal) // Make sure button respects the horizontal padding
                            .padding(.top, 8)
                        }
                        .padding(.bottom, 16)
                        
                        VStack(alignment: .leading) {

                            GenreScrollView(genres: viewModel.fetchBookGenres())
                                .frame(height: 100)

                            Text("Popular Books")
                                .font(.title)
                                .padding([.top, .leading])

                            BookRows(isSmall: false, books: viewModel.popularBooks)
                            
                            Text("New Books")
                                .font(.title)
                                .padding([.top, .leading])

                            BookRows(isSmall: true, books: viewModel.newBooks)
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
