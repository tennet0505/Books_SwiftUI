//
//  ContentView.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//

import SwiftUI
import CoreData
import Kingfisher

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
        .accentColor(.primary)
        .environmentObject(tabViewModel)
    }
}

