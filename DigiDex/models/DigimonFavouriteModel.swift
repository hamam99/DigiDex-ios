import Foundation
import SwiftData

@Model
final class DigimonFavouriteModel: Identifiable {
    var id: Int
    var image: String
    var name: String

    init(digimon: DigimonDetailResponse) {
        self.id = digimon.id
        self.image = digimon.images[0].href
        self.name = digimon.name
    }
}
