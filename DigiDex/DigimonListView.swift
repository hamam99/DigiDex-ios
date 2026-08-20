import SwiftData
import SwiftUI

struct DigimonListView: View {
    private let digimonService = DigimonService()
    @State private var digimons: [ContentDigimon] = []
    @State private var isLoading = false
    @State private var currentPage: Int = 0
    @State private var hasMorePage = true

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
                        }.onAppear {
                            Task {
                                await handleLoadMore()
                            }
                        }
                    }
                }.padding(.horizontal, 2)

                if isLoading {
                    HStack {
                        ProgressView().padding()
                    }.frame(width: .infinity)
                }
            }.navigationDestination(for: ContentDigimon.self) { item in
                DigimonDetailView(id: item.id)
            }
        }.task {
            await loadDigimons()
        }
    }

    func handleLoadMore() async {
        guard hasMorePage else { return }

        await loadDigimons()
    }

    func loadDigimons() async {
        guard hasMorePage, !isLoading else { return }
        isLoading = true

        do {
            let response = try await digimonService.getList(page: currentPage)
            if let response, !response.content.isEmpty {
                digimons.append(contentsOf: response.content)
                currentPage += 1
                hasMorePage = currentPage < response.pageable.totalPages
            } else {
                hasMorePage = false
            }
        } catch {}
        isLoading = false
    }
}

#Preview {
    DigimonListView()
}
