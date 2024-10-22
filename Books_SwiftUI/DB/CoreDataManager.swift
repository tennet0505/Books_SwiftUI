//
//  CoreDataManager.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//

import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "Books_SwiftUI") // Make sure the name matches your CoreData model
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }

    // MARK: - Context
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Fetch Books
    func fetchBooks() -> [BookEntity] {
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch books: \(error)")
            return []
        }
    }

    // MARK: - Fetch Book by ID
    func fetchBookByID(_ id: String) -> BookEntity? {
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch book with id \(id): \(error)")
            return nil
        }
    }

    // MARK: - Fetch Favorite Books
    func fetchFavoriteBooks() -> [BookEntity] {
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorite == true")

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch favorite books: \(error)")
            return []
        }
    }

    // MARK: - Add or Update Book
    func addOrUpdateBook(id: String, title: String, author: String, imageUrl: String, bookDescription: String, isFavorite: Bool, pdfUrl: String, isPopular: Bool) {
        if let bookEntity = fetchBookByID(id) {
            // Update existing book
            bookEntity.title = title
            bookEntity.author = author
            bookEntity.imageUrl = imageUrl
            bookEntity.bookDescription = bookDescription
            bookEntity.isFavorite = isFavorite
            bookEntity.pdfUrl = pdfUrl
            bookEntity.isPopular = isPopular
        } else {
            // Add new book
            let newBook = BookEntity(context: context)
            newBook.id = id
            newBook.title = title
            newBook.author = author
            newBook.imageUrl = imageUrl
            newBook.bookDescription = bookDescription
            newBook.isFavorite = isFavorite
            newBook.pdfUrl = pdfUrl
            newBook.isPopular = isPopular
        }

        saveContext()
    }

    // MARK: - Update Favorite Status
    func updateBook(book: Book, isFavorite: Bool) {
        if let bookEntity = fetchBookByID(book.id) {
            bookEntity.isFavorite = isFavorite
            saveContext()
        }
    }

    // MARK: - Remove All Books
    func removeAllBooks() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = BookEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Failed to remove all books: \(error)")
        }
    }

    // MARK: - Save Context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}
