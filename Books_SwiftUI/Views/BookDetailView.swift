//
//  BookDetailView.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//

import SwiftUI

struct BookDetailView: View {
    let book: Book

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: book.imageUrl)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300) // Adjust height as needed
                } else {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 300) // Placeholder
                }
            }

            Text(book.title)
                .font(.largeTitle)
                .padding(.top)

            Text(book.author)
                .font(.title2)
                .foregroundColor(.secondary)

            Text(book.bookDescription)
                .padding()
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding()
        .navigationTitle(book.title) // Set the navigation title
        .navigationBarTitleDisplayMode(.inline) // Set the title display mode
    }
}
