import XCTest

final class FortuneDetailViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    /// ユーザー情報と占い結果が正常に表示されることをテストする
    func testDetailView_HappyPath() throws {
        // --- 準備 ---
        // リストの最初のセルをタップして詳細画面に遷移
        let firstCell = app.collectionViews.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "ユーザーリストが表示されません")
        firstCell.tap()
        
        // --- 検証 ---
        // 1. 主要なボタンが表示されていることを確認
        let backButton = app.buttons["backButton"]
        let editButton = app.buttons["editButton"]
        XCTAssertTrue(backButton.waitForExistence(timeout: 2))
        XCTAssertTrue(editButton.waitForExistence(timeout: 2))
        
        // 2. ローディングインジケーターが消えるまで待つ (API通信が終わるまで)
        let loadingIndicator = app.otherElements["loadingIndicator"]
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == false"),
            object: loadingIndicator
        )
        wait(for: [expectation], timeout: 15)
        
        // 3. 占い結果の主要な要素が表示されるのを待機し、アサートする
        let userName = app.staticTexts["userNameText"]
        let prefectureName = app.staticTexts["prefectureNameText"]

        XCTAssertTrue(userName.waitForExistence(timeout: 5), "ユーザー名が表示されません")
        XCTAssertTrue(prefectureName.waitForExistence(timeout: 5), "都道府県名が表示されません")
        
        // 4. 表示されているテキストが空でないことを確認
        XCTAssertNotEqual(userName.label, "")
        XCTAssertNotEqual(prefectureName.label, "")
    }
    
    /// 「戻る」ボタンをタップしてリスト画面に戻れることをテストする
    func testNavigation_BackButton() throws {
        // --- 準備 ---
        // リストの最初のセルをタップして詳細画面に遷移
        let firstCell = app.collectionViews.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        firstCell.tap()
        
        // --- 操作 ---
        // 戻るボタンをタップ
        let backButton = app.buttons["backButton"]
        XCTAssertTrue(backButton.waitForExistence(timeout: 2))
        backButton.tap()
        
        // --- 検証 ---
        // リスト画面のタイトルが表示されていることを確認して、画面が戻ったと判断
        let listTitle = app.navigationBars["ともだちリスト"]
        XCTAssertTrue(listTitle.waitForExistence(timeout: 2))
    }
    
    /// 「編集」ボタンをタップしてプロフィール編集シートが表示されることをテストする
    func testNavigation_EditButton() throws {
        // --- 準備 ---
        // リストの最初のセルをタップして詳細画面に遷移
        let firstCell = app.collectionViews.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        firstCell.tap()
        
        // --- 操作 ---
        // 編集ボタンをタップ
        let editButton = app.buttons["editButton"]
        XCTAssertTrue(editButton.waitForExistence(timeout: 2))
        editButton.tap()
        
        // --- 検証 ---
        // 編集画面の「保存」ボタンが表示されることで、シートが表示されたと判断
        let saveButton = app.buttons["save"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2))
    }
}
