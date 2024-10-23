//
//  BookDetailView.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//

import SwiftUI

struct BookDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let book: Book
    @StateObject private var viewModel = BooksViewModel()
    @State private var isSharePresented: Bool = false
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: viewModel.currentBook?.imageUrl ?? "")) { phase in
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
            
            HStack(spacing: 16) {
                Button {
                    isSharePresented = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.gray)
                }
                .sheet(isPresented: $isSharePresented) {
                    ShareSheet(items: [viewModel.currentBook?.title ?? "", URL(string: viewModel.currentBook?.imageUrl ?? "") ?? ""])
                }
                Spacer()
                VStack {
                    Text(book.title)
                        .font(.largeTitle)
                        .padding(.top)
                    
                    Text(book.author)
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Button {
                    guard var updatedBook = viewModel.currentBook else { return }
                    updatedBook.isFavorite.toggle()
                    viewModel.toggleFavoriteStatus(for: updatedBook)
                } label: {
                    Image(systemName: viewModel.currentBook?.isFavorite == true ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.currentBook?.isFavorite == true ? .red : .gray)
                }

            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)

            Text(book.bookDescription)
                .padding()
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding()
        .navigationTitle(book.title) // Set the navigation title
        .navigationBarTitleDisplayMode(.inline) // Set the title display mode
        .onAppear {
            viewModel.currentBook = book
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update needed
    }
}
