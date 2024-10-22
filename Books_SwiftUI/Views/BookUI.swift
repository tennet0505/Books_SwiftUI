//
//  BookGrid.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//

import SwiftUI

struct BookRows: View {
    
    @EnvironmentObject var viewModel: BooksViewModel
    let isSmall: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach($viewModel.books) { $book in
                    NavigationLink(destination: BookDetailView(book: book)) {
                        VStack(alignment: .leading) {
                            ZStack(alignment: .center) {
                                AsyncImage(url: URL(string: book.imageUrl)) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: isSmall ? 150 : 160, height: isSmall ? 150 : 240)
                                            .cornerRadius(4)
                                    } else {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.4))
                                            .frame(width: isSmall ? 150 : 160, height: isSmall ? 150 : 240)
                                            .cornerRadius(4)
                                    }
                                }
                                
                                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.4)]),
                                               startPoint: .bottom,
                                               endPoint: .top)
                                .ignoresSafeArea()
                                .cornerRadius(4)
                                
                                VStack {
                                    HStack {
                                        Spacer()
                                        Button {
                                            var updatedBook = book
                                            updatedBook.isFavorite.toggle()
                                            viewModel.toggleFavoriteStatus(for: updatedBook)
                                        } label: {
                                            // Bind the button icon to the individual book's isFavorite status
                                            Image(systemName: book.isFavorite ? "heart.fill" : "heart")
                                                .foregroundColor(book.isFavorite ? .red : .gray)
                                        }
                                    }
                                    .padding(.top, 10)
                                    .padding(.horizontal, 10)
                                    
                                    Text(book.title)
                                        .font(.title)
                                        .lineLimit(2)
                                        .foregroundColor(Color.white)
                                        .padding(.horizontal, 4)

                                    Spacer()
                                    Text(book.author)
                                        .font(.subheadline)
                                        .foregroundColor(Color.white)
                                        .lineLimit(2)
                                        .padding(.bottom, 8)
                                        .padding(.horizontal, 4)
                                }
                            }
                            .frame(width: isSmall ? 150 : 160, height: isSmall ? 150 : 240)
                            
                            if !isSmall {
                                Text(book.title)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                Text(book.author)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                HStack(spacing: 4) {
                                    Image("Group 60")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 35, height: 18)
                                    Image(systemName: "star.fill")
                                        .foregroundColor(Color.orange)
                                    Text("4.9")
                                        .foregroundColor(Color.orange)
                                        .font(.subheadline)
                                    Spacer()
                                    Text("1.234")
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                }
                            }
                        }
                        .padding(.bottom, 10)
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: isSmall ? 150 : 300)
    }
}


// Preview
struct BookRows_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BookRows(isSmall: false)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Large Books View")
        }
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
                                .foregroundColor(Color.white)
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
                                .foregroundColor(Color.white)
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
