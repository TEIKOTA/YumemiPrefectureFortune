import XCTest

final class FortuneProfileFormViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        // テストのたびにデータをリセットしたい場合は、起動引数を設定することが多いです
        // app.launchArguments += ["-UITesting"]
        app.launch()
    }
    
    /// 新規ユーザー作成の正常系テスト
    func testCreateUser_HappyPath() throws {
        // --- 準備 ---
        let addButton = app.buttons.firstMatch
        XCTAssertTrue(addButton.waitForExistence(timeout: 1))
        addButton.firstMatch.tap()
        
        // --- 操作 ---
        // 1. 名前の入力
        let nameTextField = app.textFields["profileNameTextField"]
        XCTAssertTrue(nameTextField.waitForExistence(timeout: 1))
        nameTextField.tap()
        nameTextField.typeText("テストユーザー")
        
        // 2. 生年月日の選択
        let birthdayButton = app.buttons["birthdaySelectionButton"]
        birthdayButton.tap()
        // DatePickerそのものを取得する
        let datePicker = app.datePickers.firstMatch
        // DatePickerが表示されるまで最大2秒間待機する
        XCTAssertTrue(datePicker.waitForExistence(timeout: 2))
        // DatePickerが表示された後で、その中のボタンをタップする
        let predicate = NSPredicate(format: "label CONTAINS '15'")
        let dayButton = app.datePickers.buttons.element(matching: predicate)
        expectation(for: predicate, evaluatedWith: dayButton, handler: nil)
        waitForExpectations(timeout: 5)
        dayButton.tap()
        // 3. 血液型の選択
        let bloodTypePicker = app.buttons["bloodTypePicker"]
        bloodTypePicker.tap()
        // メニューが表示され、その中の"A"をタップする
        app.buttons["A"].tap()
        
        // 4. 保存ボタンをタップ
        let saveButton = app.buttons["save"]
        saveButton.tap()
        
        // --- 検証 ---
        // 5. フォームが閉じたことを確認
        //    (保存ボタンが存在しないことで、画面が閉じたと判断する)
        XCTAssertFalse(saveButton.waitForExistence(timeout: 2))
    }
    
    /// バリデーションエラー（名前未入力）のテスト
    func testCreateUser_ValidationError_MissingName() throws {
        // --- 準備 ---
        let addButton = app.buttons.firstMatch
        XCTAssertTrue(addButton.waitForExistence(timeout: 1))
        addButton.firstMatch.tap()
        // --- 操作 ---
        // 1. 名前は入力しない
        
        // 2. 保存ボタンをタップ
        let saveButton = app.buttons["save"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 1))
        saveButton.tap()
        
        // --- 検証 ---
        // 3. アラートが表示されることを確認
        let alert = app.alerts["入力エラー"]
        XCTAssertTrue(alert.waitForExistence(timeout: 1))
        
        // 4. エラーメッセージが正しいことを確認
        let alertMessage = "名前を入力してください。"
        XCTAssertTrue(alert.staticTexts[alertMessage].exists)
        
        // 5. アラートを閉じる
        alert.buttons["OK"].tap()
        
        // 6. フォームが閉じていないことを確認
        XCTAssertTrue(saveButton.exists)
    }
    
    /// バリデーションエラー（誕生日未入力）のテスト
    func testCreateUser_ValidationError_MissingBirthday() throws {
        // --- 準備 ---
        let addButton = app.buttons.firstMatch
        XCTAssertTrue(addButton.waitForExistence(timeout: 1))
        addButton.firstMatch.tap()
        // --- 操作 ---
        // 1. 名前と血液型は入力する
        let nameTextField = app.textFields["profileNameTextField"]
        XCTAssertTrue(nameTextField.waitForExistence(timeout: 1))
        nameTextField.tap()
        nameTextField.typeText("テストユーザー")
        
        let bloodTypePicker = app.buttons["bloodTypePicker"]
        bloodTypePicker.tap()
        app.buttons["A"].tap()
        
        // 2. 誕生日は入力せずに保存ボタンをタップ
        let saveButton = app.buttons["save"]
        saveButton.tap()
        
        // --- 検証 ---
        // 3. アラートが表示されることを確認
        let alert = app.alerts["入力エラー"]
        XCTAssertTrue(alert.waitForExistence(timeout: 1))
        
        // 4. エラーメッセージが正しいことを確認
        let alertMessage = "誕生日を入力してください。"
        XCTAssertTrue(alert.staticTexts[alertMessage].exists)
        
        // 5. アラートを閉じる
        alert.buttons["OK"].tap()
        
        // 6. フォームが閉じていないことを確認
        XCTAssertTrue(saveButton.exists)
    }
    
    /// バリデーションエラー（血液型未入力）のテスト
    func testCreateUser_ValidationError_MissingBloodType() throws {
        // --- 準備 ---
        let addButton = app.buttons.firstMatch
        XCTAssertTrue(addButton.waitForExistence(timeout: 1))
        addButton.firstMatch.tap()
        // --- 操作 ---
        // 1. 名前と誕生日は入力する
        let nameTextField = app.textFields["profileNameTextField"]
        XCTAssertTrue(nameTextField.waitForExistence(timeout: 1))
        nameTextField.tap()
        nameTextField.typeText("テストユーザー")
        
        let birthdayButton = app.buttons["birthdaySelectionButton"]
        birthdayButton.tap()
        let datePicker = app.datePickers.firstMatch
        XCTAssertTrue(datePicker.waitForExistence(timeout: 2))
        let predicate = NSPredicate(format: "label CONTAINS '15'")
        let dayButton = app.datePickers.buttons.element(matching: predicate)
        expectation(for: predicate, evaluatedWith: dayButton, handler: nil)
        waitForExpectations(timeout: 5)
        dayButton.tap()
        
        // 2. 血液型は入力せずに保存ボタンをタップ
        let saveButton = app.buttons["save"]
        saveButton.tap()
        
        // --- 検証 ---
        // 3. アラートが表示されることを確認
        let alert = app.alerts["入力エラー"]
        XCTAssertTrue(alert.waitForExistence(timeout: 1))
        
        // 4. エラーメッセージが正しいことを確認
        let alertMessage = "血液型を入力してください。"
        XCTAssertTrue(alert.staticTexts[alertMessage].exists)
        
        // 5. アラートを閉じる
        alert.buttons["OK"].tap()
        
        // 6. フォームが閉じていないことを確認
        XCTAssertTrue(saveButton.exists)
    }
}
