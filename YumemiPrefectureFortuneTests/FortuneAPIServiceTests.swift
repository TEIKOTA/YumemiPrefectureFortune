import Testing
import Foundation
import XCTest // For XCTFail
@testable import YumemiPrefectureFortune

final class FortuneAPIServiceTests {

    var apiService: FortuneAPIService!
    var session: URLSession!

    // MARK: - Helper
    
    let testBundle: Bundle = {
        guard let bundle = Bundle(identifier: "com.TEIKOTA.YumemiPrefectureFortuneTests") else {
            fatalError("テストバンドルが見つからない")
        }
        return bundle
    }()

    /// テストバンドルからJSONファイルを読み込むためのヘルパーメソッド
    private func data(forResource name: String) throws -> Data {
        let url = try #require(testBundle.url(forResource: name, withExtension: "json"))
        return try Data(contentsOf: url)
    }

    // MARK: - Setup with MockURLProtocol

    func setup(withResponseData data: Data? = nil, statusCode: Int = 200, error: Error? = nil) {
        MockURLProtocol.setHandler(handler: { request in
            if let error = error {
                throw error
            }
            let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            return (response, data)
        })
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        apiService = FortuneAPIService(session: session)
    }

    // MARK: - Tests

    @Test("正常系: FortuneAPIServiceが成功レスポンスを返す")
    func testFetchFortuneSuccess() async throws {
        let responseData = try data(forResource: "responseExample")
        setup(withResponseData: responseData)

        let requestDTO = FortuneRequestDTO(
            name: "ゆめみん",
            birthday: YMD(year: 2000, month: 1, day: 27),
            bloodType: "ab",
            today: YMD(year: 2000, month: 1, day: 27)
        )

        let result = try await apiService.fetchFortune(from: requestDTO)
        #expect(result.prefecture.name == "富山県")
        #expect(result.prefecture.capital == "富山市")
    }

    @Test("異常系: ネットワークエラーの場合、APIError.networkErrorがスローされる")
    func testFetchFortuneNetworkError() async throws {
        struct DummyError: Error {}
        setup(error: DummyError())

        let requestDTO = FortuneRequestDTO(
            name: "ゆめみん",
            birthday: YMD(year: 2000, month: 1, day: 27),
            bloodType: "ab",
            today: YMD(year: 2000, month: 1, day: 27)
        )

        do {
            _ = try await apiService.fetchFortune(from: requestDTO)
            XCTFail("Expected networkError but no error was thrown")
        } catch let error as APIError {
            switch error {
            case .networkError:
                // Test passes if networkError is caught
                break
            default:
                XCTFail("Expected networkError but got \(error)")
            }
        } catch {
            XCTFail("Expected APIError but got \(error)")
        }
    }

    @Test("異常系: レスポンスのデコードに失敗した場合、APIError.decodingErrorがスローされる")
    func testFetchFortuneDecodingError() async throws {
        let invalidJSONData = Data("invalid json".utf8)
        setup(withResponseData: invalidJSONData)

        let requestDTO = FortuneRequestDTO(
            name: "ゆめみん",
            birthday: YMD(year: 2000, month: 1, day: 27),
            bloodType: "ab",
            today: YMD(year: 2000, month: 1, day: 27)
        )

        do {
            _ = try await apiService.fetchFortune(from: requestDTO)
            XCTFail("Expected decodingError but no error was thrown")
        } catch let error as APIError {
            switch error {
            case .decodingError:
                // Test passes if decodingError is caught
                break
            default:
                XCTFail("Expected decodingError but got \(error)")
            }
        } catch {
            XCTFail("Expected APIError but got \(error)")
        }
    }
}
