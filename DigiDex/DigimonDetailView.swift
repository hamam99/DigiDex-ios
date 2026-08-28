import SwiftData
import SwiftUI

struct DigimonDetailView: View {
    @Environment(\.modelContext) private var modelContext

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
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: .infinity, height: 300, alignment: .center)
                    .clipped()

                    VStack(spacing: 8) {
                        Text(digimon?.name ?? "").font(.title3).foregroundColor(.black).bold()

                        ForEach(getListInformation(), id: \.label) { info in
                            LabelValueUi(labelValue: info)
                        }

                    }.padding(.horizontal, 12)
                }
            }

        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    onHandleFavourite()
                } label: {
                    Image(systemName: isFavourite ? "heart.fill" : "heart")
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .task {
            Task {
                await loadDigimonDetail()
                checkIfAlreadyFavourite()
            }
        }
        .ignoresSafeArea()
    }

    func getListInformation() -> [LabelValueModel] {
        let list: [LabelValueModel] = [
            LabelValueModel(
                label: "Description",
                value: [
                    digimon?.descriptions.first(where: { $0.language == "en_us" })?.description
                        ?? ""
                ]
            ),
            LabelValueModel(
                label: "Level", value: digimon?.levels.map { $0.level }
            ),
            LabelValueModel(
                label: "Attribute",
                value: digimon?.attributes.map { $0.attribute }),
            LabelValueModel(
                label: "Types",
                value: digimon?.types.map { $0.type }),
            LabelValueModel(
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
        guard let digimon, let id else {
            return
        }

        if isFavourite {
            if let existing = loadCurrentDigimonFromDb() {
                modelContext.delete(existing)
            }

        } else {
            let favourite = DigimonFavouriteModel(
                id: digimon.id,
                name: digimon.name,
                imageUrl: digimon.images[0].href
            )
            modelContext.insert(favourite)
        }

        do {
            try modelContext.save()
        } catch {
            print("error: \(error)")
        }
        isFavourite.toggle()
    }

    func loadCurrentDigimonFromDb() -> DigimonFavouriteModel? {
        guard let id else {
            return nil
        }
        let descriptor = FetchDescriptor<DigimonFavouriteModel>(
            predicate: #Predicate { $0.id == id },
        )
        if let existing: DigimonFavouriteModel = try? modelContext.fetch(descriptor).first {
            return existing
        } else {
            return nil
        }

    }

    func checkIfAlreadyFavourite() {
        if loadCurrentDigimonFromDb() != nil {
            isFavourite = true
        } else {
            isFavourite = false
        }

    }

}

#Preview {
    DigimonDetailView(id: 1)
}
