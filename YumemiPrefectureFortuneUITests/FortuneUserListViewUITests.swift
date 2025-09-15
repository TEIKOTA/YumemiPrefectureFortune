import XCTest

final class FortuneUserListViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["-UITesting"]
        app.launch()
    }

    /// リストのセルをタップして詳細画面に正しく遷移するかをテストする
    func testNavigationToDetailView() throws {
        // --- 準備 ---
        // サンプルユーザーがリストに表示されるのを待つ
        let firstCell = app.collectionViews.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "リストにユーザーが表示されません")

        // --- 操作 ---
        firstCell.tap()

        // --- 検証 ---
        // 詳細画面の「戻る」ボタンが表示されることで、画面遷移を検証する
        let backButtonOnDetail = app.buttons["backButton"]
        XCTAssertTrue(backButtonOnDetail.waitForExistence(timeout: 2), "詳細画面への遷移に失敗しました")
    }

    /// ユーザーをスワイプして削除する機能をテストする
    func testDeleteUser_byIdentifier() throws {
        // --- 準備 ---
        // サンプルユーザー「山田 太郎」を削除対象とする
        let userCell = app.staticTexts["山田 太郎"]
        XCTAssertTrue(userCell.waitForExistence(timeout: 5), "サンプルユーザー「山田 太郎」がリストに表示されません")

        // --- 操作 ---
        userCell.swipeLeft()
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 1), "スワイプ後に削除ボタンが表示されません")
        deleteButton.tap()

        // --- 検証 ---
        // ユーザーがリストから消えるのを待つ
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: userCell)
        wait(for: [expectation], timeout: 5)

        XCTAssertFalse(userCell.exists, "ユーザーがリストから削除されていません")
    }
    
    /// ユーザー削除後にリストの総数が減ることをテストする
    func testDeleteUser_ReducesCellCount() throws {
        // --- 準備 ---
        // サンプルユーザーが表示されるのを待つ
        let cells = app.collectionViews.cells
        XCTAssertTrue(cells.firstMatch.waitForExistence(timeout: 5), "リストにセルが表示されません")
        let initialCellCount = cells.count
        
        // --- 操作 ---
        // 最初のセルをスワイプして削除
        let firstCell = cells.firstMatch
        firstCell.swipeLeft()
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 1))
        deleteButton.tap()
        
        // --- 検証 ---
        // セルの総数が1つ減るのを待つ
        let predicate = NSPredicate(format: "count == %d", initialCellCount - 1)
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: cells)
        wait(for: [expectation], timeout: 5)
        
        XCTAssertEqual(cells.count, initialCellCount - 1, "セルの数が期待通りに減りませんでした")
    }
}