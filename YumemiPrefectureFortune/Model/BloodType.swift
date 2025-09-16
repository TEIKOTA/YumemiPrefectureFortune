
/// Codable に準拠することでSwiftDataにおいてStringへ自動で encode/decodeする
/// CaseIterableに準拠することでallCasesで全パターンの配列を取得可能([A, B, AB, O])
/// Identifiableに準拠することで `foreach(BloodType.allCases)`のように列挙可能
enum BloodType: String, Codable, CaseIterable, Identifiable {
    case A = "a"
    case B = "b"
    case AB = "ab"
    case O = "o"
    
    var id: Self { self }
    
    var displayName: String {
        self.rawValue.uppercased()
    }
}
