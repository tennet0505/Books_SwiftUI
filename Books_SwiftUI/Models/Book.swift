//
//  Book.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//

import Foundation

struct Book: Identifiable, Decodable, Hashable {
    var id: String
    var title: String
    var author: String
    var imageUrl: String
    var bookDescription: String
    var isFavorite: Bool = false
    var isPopular: Bool = false
    var pdfUrl: String
}

struct Genre: Decodable {
    var id: String
    var title: String
    var image: String
}

extension BookEntity {
    func convertToBook() -> Book {
        return Book(id: self.id ?? "",
                    title: self.title ?? "",
                    author: self.author ?? "",
                    imageUrl: self.imageUrl ?? "",
                    bookDescription: self.bookDescription ?? "",
                    isFavorite: self.isFavorite,
                    isPopular: self.isPopular,
                    pdfUrl: self.pdfUrl ?? ""
        )
    }
}
