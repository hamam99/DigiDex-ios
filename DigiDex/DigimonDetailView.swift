import SwiftData
import SwiftUI

struct DigimonDetailView: View {
    @Environment(\.modelContext) private var modelContext
    // @Query private var favouriteDigimon: [DigimonFavouriteModel]

    let id: Int?
    private let digimonService = DigimonService()

    @State private var digimon: DigimonDetailResponse? = nil
    @State private var isLoding: Bool = false
    @State private var isFavourite: Bool = false

    var body: some View {
        ScrollView {
            if isLoding {
                ProgressView("Loading...")
            } else if digimon == nil {
                Text("No digimon displayed")
            } else {
                VStack(alignment: .center, spacing: 8) {
                    AsyncImage(url: URL(string: digimon?.images[0].href ?? "")) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: .infinity, height: 300, alignment: .center)
                    .clipped()

                    VStack(spacing: 8) {
                        Text(digimon?.name ?? "").font(.title3).foregroundColor(.black).bold()

                        ForEach(getListInformation(), id: \.label) { info in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(info.label).font(.callout).bold()
                                HStack {
                                    ForEach(info.value ?? [], id: \.self) { val in

                                        if val.hasPrefix("http") {
                                            AsyncImage(url: URL(string: val)) { image in
                                                image.resizable().scaledToFill()
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width: 40, height: 40)
                                            .clipped()
                                        } else {
                                            Text(val).font(.caption)
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }.padding(.horizontal, 12)
                }.overlay(alignment: .topTrailing) {
                    Button {
                        onHandleFavourite()
                    } label: {
                        Image(systemName: isFavourite ? "heart.fill" : "heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .padding(.horizontal, 24)
                    }.buttonStyle(.plain)

                }
            }

        }.task {
            Task {
                await loadDigimonDetail()
                checkIfAlreadyFavourite()
            }
        }
    }

    func getListInformation() -> [LabelValue] {
        let list: [LabelValue] = [
            LabelValue(
                label: "Description",
                value: [
                    digimon?.descriptions.first(where: { $0.language == "en_us" })?.description
                        ?? ""
                ]
            ),
            LabelValue(
                label: "Level", value: digimon?.levels.map { $0.level }
            ),
            LabelValue(
                label: "Attribute",
                value: digimon?.attributes.map { $0.attribute }),
            LabelValue(
                label: "Fields", value: digimon?.fields.map { $0.image }),
        ]
        return list
    }

    func loadDigimonDetail() async {
        guard id != nil else {
            return
        }

        do {
            isLoding = true
            let response = try await digimonService.getDetail(id: id!)
            digimon = response
        } catch {
        }
        isLoding = false
    }

    func onHandleFavourite() {
        guard digimon != nil else {
            return
        }


        let favourite = DigimonFavouriteModel(
            id: digimon!.id,
            name: digimon!.name,
            imageUrl: digimon!.images[0].href
        )
        
        print("isFavourite:\(isFavourite) \(favourite.id), \(favourite.name), \(favourite.imageUrl)")

        if isFavourite {
            modelContext.delete(favourite)
        } else {
            modelContext.insert(favourite)
        }
        try? modelContext.save()
        isFavourite = !isFavourite
    }

    func checkIfAlreadyFavourite() {
        guard let id else {
            return
        }

        let descriptor = FetchDescriptor<DigimonFavouriteModel>(
            predicate: #Predicate { $0.id == id },
        )

        let favourite = try? modelContext.fetch(descriptor).first
        isFavourite = favourite != nil
    }
}

#Preview {
    DigimonDetailView(id: 1)
}
