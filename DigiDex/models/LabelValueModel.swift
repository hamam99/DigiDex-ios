// MARK: - Content
struct LabelValueModel: Decodable, Hashable {
    let label: String
    let value: [String]?
}
