
/// Codable に準拠することでSwiftDataにおいてStringへ自動で encode/decodeする
enum BloodType: String, Codable {
    case A = "a"
    case B = "b"
    case AB = "ab"
    case O = "o"
}
