//
//  GenreRows.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 25/10/2024.
//

import SwiftUI
import Kingfisher

struct GenreRows: View {
    @Namespace private var animation //Animation for cells!!!
    @State private var showingSheet = false
    @State private var genre: Genre?
    
    let genres: [Genre]
    
    var body: some View {
        ZStack {
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
                        .onTapGesture {
                            self.genre = genre
                            showingSheet.toggle()
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .fullScreenCover(isPresented: $showingSheet) {
            GenreCollectionView(genre: self.genre ?? Genre(id: "1", title: "", image: ""))
        }
    }
}

struct GenreCollectionView: View {
    @Namespace private var animation
    var genre: Genre
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: BooksViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("Close")
                }
                .padding()
            }
            Text(genre.title)
                .font(.largeTitle)
                .padding(.bottom)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: -64) {
                    ForEach(viewModel.booksByGenre, id: \.title) { book in
                        GeometryReader { proxy in
                            let cardSize = proxy.size
                            VStack {
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
                                        .frame(width: cardSize.width, height:  cardSize.height)
                                        .clipped()
                                        .cornerRadius(4)
                                    
                                    LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.4)]),
                                                   startPoint: .bottom,
                                                   endPoint: .top)
                                    .ignoresSafeArea()
                                    .cornerRadius(16)
                                    
                                    VStack {
                                        Text(book.title)
                                            .font(.system(size: 48))
                                            .lineLimit(2)
                                            .foregroundColor(Color.white)
                                            .padding(.horizontal, 4)
                                            .padding(.top, 32)
                                        Spacer()
                                        Text(book.author)
                                            .font(.title)
                                            .foregroundColor(Color.white)
                                            .lineLimit(2)
                                            .padding(.bottom, 32)
                                            .padding(.horizontal, 4)
                                    }
                                }
                            }
                        }
                        .cornerRadius(16)
                        .frame(width: UIScreen.main.bounds.width - 64)
                        .padding(.horizontal, 32)
                        .scrollTransition( .interactive, axis: .horizontal) { view, phase in
                            view.scaleEffect(phase.isIdentity ? 1 : 0.95)
                            
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
        .onAppear {
            viewModel.fetchGenreBooks()
        }
    }
}

struct GenreCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = BooksViewModel()
        viewModel.books = [
            Book(id: "1", title: "Adventures",
                 author: "Mark Twain", imageUrl: "",
                 bookDescription: "The novel follows the journey of a young boy named Huckleberry Finn and a runaway slave named Jim as they travel down the Mississippi River on a raft. Set in the American South before the Civil War, the story explores themes of friendship, freedom, and the hypocrisy of society.",
                 isPopular: true,
                 pdfUrl: "https://www.soundczech.cz/temp/lorem-ipsum.pdf"),
            Book(id: "1", title: "Adventures",
                 author: "Mark Twain", imageUrl: "",
                 bookDescription: "The novel follows the journey of a young boy named Huckleberry Finn and a runaway slave named Jim as they travel down the Mississippi River on a raft. Set in the American South before the Civil War, the story explores themes of friendship, freedom, and the hypocrisy of society. Through various adventures and encounters with a host of colorful characters, Huck grapples with his personal values, often clashing with the societal norms of the time.",
                 isPopular: true,
                 pdfUrl: "https://www.soundczech.cz/temp/lorem-ipsum.pdf"),
            Book(id: "1", title: "Adventures",
                 author: "Mark Twain", imageUrl: "",
                 bookDescription: "The novel follows the journey of a young boy named Huckleberry Finn and a runaway slave named Jim as they travel down the Mississippi River on a raft. Set in the American South before the Civil War, the story explores themes of friendship, freedom, and the hypocrisy of society. Through various adventures and encounters with a host of colorful characters, Huck grapples with his personal values, often clashing with the societal norms of the time.",
                 isPopular: true,
                 pdfUrl: "https://www.soundczech.cz/temp/lorem-ipsum.pdf")
           
        ]

        return GenreCollectionView(genre: Genre(id: "1", title: "", image: ""))
            .environmentObject(viewModel) // Inject viewModel as an environment object
    }
}
