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
    @Query private var items: [Item]

    var body: some View {
        ZStack {
            TabView {
                DigimonListView().tabItem({
                    Image(systemName: "list.bullet.below.rectangle")
                    Text("Digimon")
                })

                DigimonListFavouriteView().tabItem({
                    Image(systemName: "heart.fill")
                    Text("Favourites")
                })
            }
        }
    }
}

struct DigimonListView: View {
    var body: some View {
        NavigationStack {
            Text("Digimon List").navigationTitle("Digimon")
        }
    }
}

struct DigimonListFavouriteView: View {
    var body: some View {
        NavigationStack {
            Text("Digimon Favourites").navigationTitle("Favourites")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
