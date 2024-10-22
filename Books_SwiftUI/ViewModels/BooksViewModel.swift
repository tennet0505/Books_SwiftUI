//
//  BooksViewModel.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//


import Combine
import SwiftUI


import Foundation
import Combine

class BooksViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var popularBooks: [Book] = []
    @Published var newBooks: [Book] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    var apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    // MARK: - Fetch Books from API and Filter Popular/New Books
    func fetchBooks(isLoading: Bool = false) {
        self.isLoading = isLoading
        let existingFavoriteIDs = fetchFavoriteBookIDs()
        
        apiService.fetchBooks()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = self.handleError(error)
                }
            }, receiveValue: { [weak self] books in
                guard let self = self else { return }
                self.books = books
                self.reapplyFavorites(existingFavoriteIDs)
                self.filterAllBooks()  // Filter books into popular and new
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Filter Popular and New Books
    private func filterAllBooks() {
        // Popular books: Books that are marked as popular in Core Data
        popularBooks = CoreDataManager.shared.fetchBooks()
            .filter { $0.isPopular } // Filter only popular books
            .map { $0.convertToBook() } // Convert Core Data entities to Book model
        
        // New books: Books that are not marked as popular
        newBooks = CoreDataManager.shared.fetchBooks()
            .filter { !$0.isPopular } // Filter only new books
            .map { $0.convertToBook() } // Convert Core Data entities to Book model
    }

    // MARK: - Reapply Favorites to Books After Fetching
    private func reapplyFavorites(_ favoriteIDs: Set<String>) {
        for id in favoriteIDs {
            if let index = books.firstIndex(where: { $0.id == id }) {
                books[index].isFavorite = true // Reapply favorite status
            }
        }
    }

    // MARK: - Fetch Favorite Book IDs
    private func fetchFavoriteBookIDs() -> Set<String> {
        // Fetch favorite books from Core Data and return their IDs
        let favoriteBookIDs = CoreDataManager.shared.fetchFavoriteBooks().map { $0.id ?? "" }
        return Set(favoriteBookIDs)
    }
    
    // MARK: - Fetch Book Genres
    func fetchBookGenres() -> [Genre] {
        // Static array of genres
        let genreArray: [Genre] = [
            Genre(title: "Fantasy", image: "logoGenre"),
            Genre(title: "Science Fiction", image: "logoGenre"),
            Genre(title: "Mystery", image: "logoGenre"),
            Genre(title: "Horror", image: "logoGenre"),
            Genre(title: "Biography", image: "logoGenre"),
            Genre(title: "Humor", image: "logoGenre"),
            Genre(title: "Novel", image: "logoGenre")
        ]
        return genreArray
    }
    
    // MARK: - Handle API Error
    private func handleError(_ error: APIError) -> String {
        switch error {
        case .invalidURL:
            return "Invalid URL."
        case .requestFailed:
            return "Network request failed."
        case .decodingFailed:
            return "Failed to decode response."
        }
    }
    
    // MARK: - Toggle Favorite Status for a Book
    func toggleFavoriteStatus(for book: Book) {
        // Update favorite status in Core Data
        CoreDataManager.shared.updateBook(book: book, isFavorite: book.isFavorite ?? false)
        
        // Update favorite status in local books array
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index].isFavorite = book.isFavorite
        }
    }
    
    // MARK: - Fetch a Single Book by ID
    func fetchBookById(_ id: String) -> Book? {
        if let bookEntity = CoreDataManager.shared.fetchBookByID(id) {
            return bookEntity.convertToBook()
        } else {
            return nil
        }
    }
}