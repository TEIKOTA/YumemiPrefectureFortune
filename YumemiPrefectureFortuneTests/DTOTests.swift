import Testing
import Foundation

@testable import YumemiPrefectureFortune

struct DTOTests {

    // MARK: - Helper
    
    let testBundle: Bundle = {
            guard let bundle = Bundle(identifier: "com.TEIKOTA.YumemiPrefectureFortuneTests") else {
                fatalError("テストバンドルが見つからない")
            }
            return bundle
        }()
    
    private func data(forResource name: String) throws -> Data {
        let url = try #require(testBundle.url(forResource: name, withExtension: "json"))
        return try Data(contentsOf: url)
    }

    // MARK: - Encoding Test

    @Test("FortuneRequestDTOをJSONに正しくエンコードできる")
    func testEncodingFortuneRequestDTO() throws {

        let requestDTO = FortuneRequestDTO(
            name: "ゆめみん",
            birthday: YMD(year: 2000, month: 1, day: 27),
            bloodType: "ab",
            today: YMD(year: 2000, month: 1, day: 27)
        )
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let resultData = try encoder.encode(requestDTO)
        
        let expectedData = try data(forResource: "requestExample")
        
        // キーの順序に依存しないように、辞書に変換して比較する
        let resultJSON = try #require(JSONSerialization.jsonObject(with: resultData) as? NSDictionary)
        let expectedJSON = try #require(JSONSerialization.jsonObject(with: expectedData) as? NSDictionary)
        
        #expect(resultJSON == expectedJSON)
    }

    // MARK: - Decoding Test

    @Test("PrefectureのJSONを正しくデコードできる")
    func testDecodingPrefecture() throws {
        
        let jsonData = try data(forResource: "responseExample")
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let prefecture = try decoder.decode(Prefecture.self, from: jsonData)
        
        #expect(prefecture.name == "富山県")
        #expect(prefecture.capital == "富山市")
        
        // JSONファイル内の改行は、デコード後は \n として扱われる
        let expectedBrief = "富山県（とやまけん）は、日本の中部地方に位置する県。県庁所在地は富山市。\n中部地方の日本海側、新潟県を含めた場合の北陸地方のほぼ中央にある。\n※出典: フリー百科事典『ウィキペディア（Wikipedia）』"
        #expect(prefecture.brief == expectedBrief)
        
        #expect(prefecture.citizenDay?.month == 5)
        #expect(prefecture.citizenDay?.day == 9)
        #expect(prefecture.hasCoastLine == true)
        #expect(prefecture.logoUrl.absoluteString == "https://japan-map.com/wp-content/uploads/toyama.png")
    }
}
