//
//  BookGrid.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//

import SwiftUI

struct BookRows: View {
    let isSmall: Bool
    let books: [Book]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(books) { book in
                    NavigationLink(destination: BookDetailView(book: book)) {
                        VStack(alignment: .leading) {
                            AsyncImage(url: URL(string: book.imageUrl)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: isSmall ? 150 : 160, height: isSmall ? 150 : 240)
                                        .cornerRadius(8)
                                } else {
                                    Rectangle()
                                        .fill(Color.gray)
                                        .frame(width: isSmall ? 150 : 160, height: isSmall ? 150 : 240)
                                        .cornerRadius(8)
                                }
                            }
                            Text(book.title)
                                .font(.headline)
                            Text(book.author)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.bottom, 10)
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: isSmall ? 210 : 300) // Adjust height as needed
    }
}


struct BookGrid: View {
    let books: [Book]
    
    // Define two columns
    private var columns: [GridItem] {
        [GridItem(.flexible()), GridItem(.flexible())] // Two flexible columns
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) { // Use LazyVGrid for grid layout
                ForEach(books) { book in
                    NavigationLink(destination: BookDetailView(book: book)) {
                        VStack(alignment: .leading) {
                            AsyncImage(url: URL(string: book.imageUrl)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: (UIScreen.main.bounds.width - 48) / 2, height: 240)
                                        .cornerRadius(8)
                                } else {
                                    Rectangle()
                                        .fill(Color.gray)
                                        .frame(width: (UIScreen.main.bounds.width - 48) / 2, height: 240)
                                        .cornerRadius(8)
                                }
                            }
                            Text(book.title)
                                .font(.headline)
                                .lineLimit(1) // Keep title to one line
                                .minimumScaleFactor(0.5) // Allow text to shrink
                            Text(book.author)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.bottom, 10)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct BookRow: View {
    let books: [Book]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(books) { book in
                NavigationLink(destination: BookDetailView(book: book)) {
                    HStack(spacing: 8) {
                        AsyncImage(url: URL(string: book.imageUrl)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 75)
                                    .cornerRadius(2)
                            } else {
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 50, height: 75)
                                    .cornerRadius(2)
                            }
                        }
                        VStack(alignment: .leading) {
                            Text(book.title)
                                .font(.headline)
                                .lineLimit(2) // Keep title to one line
                                .minimumScaleFactor(0.5) // Allow text to shrink
                            Text(book.author)
                                .font(.subheadline)
                                .lineLimit(2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.bottom, 10)
                }
            }
            .padding(.horizontal)
        }
    }
}
