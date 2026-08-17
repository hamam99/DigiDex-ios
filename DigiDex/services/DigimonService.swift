import Alamofire
import Foundation

// MARK: - DigimonListResponse
struct DigimonListResponse: Decodable, Hashable {
    let content: [ContentDigimon]
    let pageable: Pageable
}

// MARK: - Content
struct ContentDigimon: Decodable, Hashable, Identifiable {
    let id: Int
    let name: String
    let href: String
    let image: String
}

// MARK: - Pageable
struct Pageable: Decodable, Hashable {
    let currentPage, elementsOnPage, totalElements, totalPages: Int
    let previousPage: String
    let nextPage: String
}

// MARK: - DigimonDetailResponse
struct DigimonDetailResponse: Decodable, Hashable, Identifiable {
    let id: Int
    let name: String
    let xAntibody: Bool
    let images: [DigimonImage]
    let levels: [Level]
    let types: [TypeElement]
    let attributes: [Attribute]
    let fields: [Field]
    let releaseDate: String
    let descriptions: [Description]
    let skills: [Skill]
    let priorEvolutions, nextEvolutions: [Evolution]
}

// MARK: - Attribute
struct Attribute: Decodable, Hashable, Identifiable {
    let id: Int
    let attribute: String
}

// MARK: - Description
struct Description: Decodable, Hashable {
    let origin, language, description: String
}

// MARK: - Field
struct Field: Decodable, Hashable, Identifiable {
    let id: Int
    let field: String
    let image: String
}

// MARK: - DigimonImage
struct DigimonImage: Decodable, Hashable {
    let href: String
    let transparent: Bool
}

// MARK: - Level
struct Level: Decodable, Hashable, Identifiable {
    let id: Int
    let level: String
}

// MARK: - Evolution
struct Evolution: Decodable, Hashable, Identifiable {
    let id: Int
    let digimon, condition: String
    let image: String
    let url: String
}

// MARK: - Skill
struct Skill: Decodable, Hashable, Identifiable {
    let id: Int
    let skill: String
    let translation: String
    let description: String
}

// MARK: - TypeElement
struct TypeElement: Decodable, Hashable, Identifiable {
    let id: Int
    let type: String
}

let BASE_URL = "https://digi-api.com/api/v1/digimon"
let FULL_URL = BASE_URL

struct DigimonService {

    func getList(page: Int = 0) async throws -> DigimonListResponse? {
        do {
            let params: Parameters = [
                "page": page,
                "pageSize": 45,
            ]

            let response = try await AF.request(
                FULL_URL,
                method: .get,
                parameters: params
            )
            .cacheResponse(using: .cache)
            .validate()
            .serializingData()
            .value
            let decodeResponse = try JSONDecoder().decode(DigimonListResponse.self, from: response)
            return decodeResponse

        } catch {
            return nil
        }
    }

    func getDetail(id: Int) async throws -> DigimonDetailResponse? {

        do {
            let response = try await AF.request(
                "\(FULL_URL)/\(id)",
                method: .get,
            ).cacheResponse(using: .cache)
                .validate()
                .serializingData()
                .value
            let decodeRespose = try JSONDecoder().decode(DigimonDetailResponse.self, from: response)
            return decodeRespose
        } catch {
            return nil
        }
    }
}
