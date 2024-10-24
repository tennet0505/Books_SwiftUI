//
//  ContentView.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var tabViewModel = TabViewModel()
    var body: some View {
        TabView(selection: $tabViewModel.selectedTab) {
            NavigationStack {
                BooksView()
                    
            }
            .tint(.white)
            .navigationTitle("Books")
            
            .tabItem {
                Image(systemName: "book")
                Text("Home")
            }
            .tag(0)
            NavigationStack {
                MyLibraryView()
            }
            .tint(.white)
            .navigationTitle("My library")
            
            .tabItem {
                Image(systemName: "books.vertical")
                Text("Favorites")
            }
            .tag(1)
            NavigationStack {
                SearchView()
            }
            .tint(.white)
            .navigationTitle("Search")
            
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Settings")
            }
            .tag(2)
        }
        .accentColor(.white)
        .environmentObject(tabViewModel)
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
