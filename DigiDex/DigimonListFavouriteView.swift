import SwiftData
import SwiftUI

struct DigimonListFavouriteView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DigimonFavouriteModel.id) private var digimons: [DigimonFavouriteModel] = []

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 3
    )

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(digimons, id: \.id) { digimon in
                        NavigationLink(value: digimon) {
                            VStack(spacing: 0) {
                                AsyncImage(url: URL(string: digimon.imageUrl)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 115, height: 110)
                                .clipped()
                                .padding(4)
                                Text(digimon.name).font(.caption2).foregroundColor(.black)
                                    .lineLimit(1).padding(.horizontal, 4)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3))
                            )
                        }
                    }
                }.padding(.horizontal, 2)
            }.navigationDestination(for: DigimonFavouriteModel.self) { item in
                DigimonDetailView(id: item.id)
            }
        }
    }
}

#Preview {
    DigimonListFavouriteView()
}
