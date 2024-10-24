//
//  BookGrid.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//

import SwiftUI
import Kingfisher

struct BookRows: View {
    
    @Namespace private var animation //Animation for cells!!!
    @EnvironmentObject var viewModel: BooksViewModel
    let isSmall: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(!isSmall ? $viewModel.popularBooks : $viewModel.newBooks) { $book in
                    NavigationLink(destination:
                                    BookDetailView(book: book)
                        .navigationTransition(.zoom(sourceID: book.id, in: animation))) {  //Animation for cells!!!
                            
                        VStack(alignment: .leading) {
                            ZStack(alignment: .center) {
                                KFImage(URL(string: book.imageUrl))
                                    .resizable()
                                    .serialize(as: .PNG)
                                    .onSuccess { result in
                                        print("Image loaded from cache: \(result.cacheType)")
                                    }
                                    .onFailure { error in
                                        print("Error: \(error)")
                                    }.placeholder { p in
                                        ProgressView(p)
                                    }
                                    .scaledToFill()
                                    .frame(width: isSmall ? 150 : 160, height: isSmall ? 150 : 240)
                                    .clipped()
                                    .cornerRadius(4)
                    
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
                        .matchedTransitionSource(id: book.id, in: animation) { configuration in
                            configuration.background(.clear) //Animation for cells!!!
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: isSmall ? 150 : 300)
    }
}

struct BookGrid: View {
    
    @Namespace private var animation 
    let books: [Book]
    
    // Define two columns
    private var columns: [GridItem] {
        [GridItem(.flexible()), GridItem(.flexible())] // Two flexible columns
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 8) { // Use LazyVGrid for grid layout
                ForEach(books) { book in
                    NavigationLink(destination:
                                    BookDetailView(book: book)
                        .navigationTransition(.zoom(sourceID: book.id, in: animation))
                                   
                    ) {
                        VStack(alignment: .leading) {
                            ZStack(alignment: .center) {
                                KFImage(URL(string: book.imageUrl))
                                    .resizable()
                                    .serialize(as: .PNG)
                                    .onSuccess { result in
                                        print("Image loaded from cache: \(result.cacheType)")
                                    }
                                    .onFailure { error in
                                        print("Error: \(error)")
                                    }.placeholder { p in
                                        ProgressView(p)
                                    }
                                    .scaledToFill()
                                    .frame(width: 160, height: 240)
                                    .clipped()
                                    .cornerRadius(4)
                    
                                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.4)]),
                                               startPoint: .bottom,
                                               endPoint: .top)
                                .ignoresSafeArea()
                                .cornerRadius(4)
                                
                                VStack {
                                    Text(book.title)
                                        .font(.title)
                                        .lineLimit(2)
                                        .foregroundColor(Color.white)
                                        .padding(.horizontal, 4)
                                        .padding(.top, 24)
                                    Spacer()
                                    Text(book.author)
                                        .font(.subheadline)
                                        .foregroundColor(Color.white)
                                        .lineLimit(2)
                                        .padding(.bottom, 8)
                                        .padding(.horizontal, 4)
                                }
                            }
                            .frame(width: 160, height: 240)
                        }
                        .padding(.bottom, 10)
                        .matchedTransitionSource(id: book.id, in: animation) { configuration in
                            configuration.background(.clear)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct BookRow: View {
    
    @Namespace private var animation
    let books: [Book]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(books) { book in
                    NavigationLink(destination:
                                    BookDetailView(book: book)
                        .navigationTransition(.zoom(sourceID: book.id, in: animation))
                    ) {
                        HStack(spacing: 8) {
                            KFImage(URL(string: book.imageUrl))
                                .resizable()
                                .serialize(as: .PNG)
                                .onSuccess { result in
                                    print("Image loaded from cache: \(result.cacheType)")
                                }
                                .onFailure { error in
                                    print("Error: \(error)")
                                }
                                .placeholder { p in
                                    ProgressView(p)
                                }
                                .scaledToFill()
                                .frame(width: 50, height: 75)
                                .clipped()
                                .cornerRadius(4)
                            
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                    .foregroundColor(Color.white)
                                Text(book.author)
                                    .font(.subheadline)
                                    .lineLimit(2)
                                    .foregroundColor(.secondary)
                                HStack(spacing: 4) {
                                    Image("Group 60")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 30, height: 15)
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
                        .matchedTransitionSource(id: book.id, in: animation) { configuration in
                            configuration.background(.clear)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
