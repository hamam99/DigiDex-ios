import SwiftData
import SwiftUI

struct DigimonListView: View {
    var body: some View {
        NavigationStack {
            Text("Digimon Favourites").navigationTitle("Favourites")
        }
    }
}

#Preview {
    DigimonListView()
}
