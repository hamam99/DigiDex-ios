//
//  DigiDexApp.swift
//  DigiDex
//
//  Created by Hamam Nasrodin on 12/08/2026.
//

import SwiftData
import SwiftUI

@main
struct DigiDexApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            DigimonFavouriteModel.self
        ])

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        let modelContainer: ModelContainer
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            if let url = modelContainer.configurations.first?.url {
                          print("SwiftData Storage Location: \(url.path)")
            }
            
            return modelContainer
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
