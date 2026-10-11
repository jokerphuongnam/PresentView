import PresentView
import XCTest

final class PresentedStackTests: XCTestCase {
    func testEachStyleAppendsOntoOneArray() {
        var presented: [Presented<String>] = []
        presented.sheet(item: "sheet", animation: nil)
        presented.fullScreenCover(item: "cover", animation: nil)
        presented.dialog(item: "dialog", animation: nil)
        presented.popover(item: "popover", animation: nil)
        presented.overlay(item: "overlay", animation: nil)
        presented.context(item: "context", parentFrame: CGRect(x: 1, y: 2, width: 3, height: 4), animation: nil)

        XCTAssertEqual(presented.map(\.item), ["sheet", "cover", "dialog", "popover", "overlay", "context"])
    }

    func testPopRemovesOnlyTheTop() {
        var presented: [Presented<String>] = []
        presented.sheet(item: "A", animation: nil)
        presented.dialog(item: "B", animation: nil)

        XCTAssertEqual(presented.pop(), "B")
        XCTAssertEqual(presented.map(\.item), ["A"])
        var empty: [Presented<String>] = []
        XCTAssertNil(empty.pop())
    }

    func testSafeSubscriptReturnsTheItemAtThatIndex() {
        var presented: [Presented<String>] = []
        presented.overlay(item: "A", animation: nil)

        XCTAssertEqual(presented[safe: 0], "A")
        XCTAssertNil(presented[safe: 1])
        XCTAssertNil(presented[safe: -1])
    }

    func testDialogKeepsItsDismissHandler() {
        var fired = false
        var presented: [Presented<String>] = []
        presented.dialog(item: "A", canCloseWhenTapBackground: false, animation: nil) {
            fired = true
        }

        XCTAssertFalse(presented[0].canCloseWhenTapBackground)
        presented[0].onDismiss?()
        XCTAssertTrue(fired)
    }
}
