
/// Codable に準拠することでSwiftDataにおいてStringへ自動で encode/decodeする
/// CaseIterableに準拠することでallCasesで全パターンの配列を取得可能([A, B, AB, O])
enum BloodType: String, Codable, CaseIterable {
    case A = "a"
    case B = "b"
    case AB = "ab"
    case O = "o"
}
