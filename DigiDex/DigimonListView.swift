import SwiftData
import SwiftUI

struct DigimonListView: View {
    private let digimonService = DigimonService()
    @State private var digimons: [ContentDigimon] = []
    @State private var isLoading = false
    @State private var currentPage: Int = 0

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        // repeating: GridItem(.adaptive(minimum: 140, maximum: 140), spacing: 0),
        count: 3
    )

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(digimons, id: \.id) { digimon in
                        NavigationLink(value: digimon) {
                            VStack(spacing: 0) {
                                AsyncImage(url: URL(string: digimon.image)) { image in
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
                }
                .padding(.horizontal, 2)
            }
        }.task {
            await loadDigimons()
        }
    }

    func loadDigimons() async {
        isLoading = true

        do {
            let response = try await digimonService.getList(page: currentPage)
            digimons.append(contentsOf: response?.content ?? [])
            currentPage += 1
        } catch {}
        isLoading = false
    }
}

#Preview {
    DigimonListView()
}
