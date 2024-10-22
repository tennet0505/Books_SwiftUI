//
//  BookGrid.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//

import SwiftUI
 
struct BookGrid: View {
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
