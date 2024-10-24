//
//  BooksView.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//

import SwiftUI

struct BooksView: View {
    
//    @Namespace private var animation
    @State private var searchText = ""
    @EnvironmentObject var viewModel: BooksViewModel
    @EnvironmentObject var tabViewModel: TabViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            if viewModel.isLoading {
                ProgressView("Loading books...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                ScrollView(showsIndicators: false) {
                    ZStack {
                        TextField("Books & Authors", text: $searchText)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
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
                    
                    if viewModel.books.isEmpty {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    } else {
                        
                        VStack(alignment: .leading) {
                            GenreScrollView(genres: viewModel.fetchBookGenres())
                                .frame(height: 100)
                            
                            Text("Popular Books")
                                .font(.title)
                                .padding([.top, .leading])
                            
                            BookRows(isSmall: false)
                            
                            Text("New Books")
                                .font(.title)
                                .padding([.top, .leading])
                            
                            BookRows(isSmall: true)
                        }
                    }
                }
            }
        }
        .navigationTitle("Books")
        .onAppear {
            viewModel.fetchBooks() // Fetch books when view appears
        }
        .onTapGestureToDismissKeyboard()
    }
}
