//
//  BookDetailView.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//

import SwiftUI
import Kingfisher

struct BookDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let book: Book
    @StateObject private var viewModel = BooksViewModel()
    @State private var isSharePresented: Bool = false

    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                GeometryReader { geometry in
                    let scale = calculateScale(from: geometry)
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
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                        .clipped()
                        .scaleEffect(scale)
                        .offset(y: calculateOffset(from: geometry))
                    
                }.frame(height: 300)
                
                HStack(spacing: 16) {
                    Button {
                        isSharePresented = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.gray)
                    }
                    .sheet(isPresented: $isSharePresented) {
                        ShareSheet(items: [viewModel.currentBook?.title ?? "", URL(string: viewModel.currentBook?.imageUrl ?? "") ?? ""])
                            .presentationDetents([.medium, .large])
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
        }
        .navigationBarTitleDisplayMode(.inline) // Set the title display mode
        .onAppear {
            viewModel.currentBook = book
        }
    }
    
    // Calculate scale based on scroll offset
    func calculateScale(from geometry: GeometryProxy) -> CGFloat {
        let offsetY = geometry.frame(in: .global).minY
        let scale = max(1.0, 1.0 + (offsetY / 300))
        return scale
    }
    
    func calculateOffset(from geometry: GeometryProxy) -> CGFloat {
        let offsetY = geometry.frame(in: .global).minY
        return offsetY > 0 ? -offsetY : 0
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
