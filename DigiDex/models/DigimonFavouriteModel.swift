import Foundation
import SwiftData

@Model
final class DigimonFavouriteModel: Identifiable {
    var id: Int
    var name: String
    var imageUrl: String

    init(id: Int, name: String, imageUrl: String, ) {
        self.id = id
        self.imageUrl = imageUrl
        self.name = name
    }
}
