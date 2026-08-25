//
//  ContentView.swift
//  DigiDex
//
//  Created by Hamam Nasrodin on 12/08/2026.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var favouriteDigimon: [DigimonFavouriteModel]

    var body: some View {
        ZStack {
            TabView {
                DigimonListView().tabItem {
                    Image(systemName: "list.bullet.below.rectangle")
                    Text("Digimon")
                }

                DigimonListFavouriteView().tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favourites")
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: DigimonFavouriteModel.self, inMemory: true)
}
