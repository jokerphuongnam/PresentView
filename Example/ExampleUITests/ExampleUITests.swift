import XCTest

final class ExampleUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testSheetOpensAndDismisses() {
        let app = launch()
        app.buttons["open-sheet"].tap()
        let dismiss = app.buttons["dismiss-presented"]
        XCTAssertTrue(dismiss.waitForExistence(timeout: 3))
        dismiss.tap()
        XCTAssertTrue(app.buttons["open-sheet"].waitForExistence(timeout: 3))
    }

    func testDialogOpensAndDismisses() {
        let app = launch()
        app.buttons["open-dialog"].tap()
        let dismiss = app.buttons["dismiss-presented"]
        XCTAssertTrue(dismiss.waitForExistence(timeout: 3))
        dismiss.tap()
        XCTAssertTrue(app.buttons["open-dialog"].waitForExistence(timeout: 3))
    }

    func testOverlayOpensAndDismisses() {
        let app = launch()
        app.buttons["open-overlay"].tap()
        let dismiss = app.buttons["dismiss-presented"]
        XCTAssertTrue(dismiss.waitForExistence(timeout: 3))
        dismiss.tap()
        XCTAssertTrue(app.buttons["open-overlay"].waitForExistence(timeout: 3))
    }

    func testFullScreenCoverOpensAndDismisses() {
        let app = launch()
        app.buttons["open-cover"].tap()
        let dismiss = app.buttons["dismiss-presented"]
        XCTAssertTrue(dismiss.waitForExistence(timeout: 3))
        dismiss.tap()
        XCTAssertTrue(app.buttons["open-cover"].waitForExistence(timeout: 3))
    }

    private func launch() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.buttons["open-sheet"].waitForExistence(timeout: 5))
        return app
    }
}
