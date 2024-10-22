//
//  Books_SwiftUIApp.swift
//  Books_SwiftUI
//
//  Created by Oleg Ten on 22/10/2024.
//

import SwiftUI

@main
struct Books_SwiftUIApp: App {
    let persistenceController = CoreDataManager.shared
    @StateObject private var booksViewModel = BooksViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.persistentContainer.viewContext)
                .environmentObject(booksViewModel)
        }
    }
}
