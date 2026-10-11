import PresentView
import SwiftUI
import XCTest

final class PresentedStyleTests: XCTestCase {
    func testEachCaseMatchesItsPresentedType() {
        XCTAssertTrue(Presented.sheet(item: "A") == .sheet)
        XCTAssertTrue(Presented.fullScreenCover(item: "A") == .fullScreenCover)
        XCTAssertTrue(Presented.popover(item: "A") == .popover)
        XCTAssertTrue(Presented.overlay(item: "A", background: AnyView(Color.clear)) == .overlay)
    }

    func testDialogAndContextDrawThroughTheOverlayPath() {
        XCTAssertTrue(Presented.dialog(item: "A") == .overlay)
        XCTAssertTrue(Presented<String>.context(item: "A", parentFrame: .zero, background: AnyView(Color.clear)) == .overlay)
        XCTAssertFalse(Presented.dialog(item: "A") == .sheet)
        XCTAssertFalse(Presented.sheet(item: "A") == .overlay)
    }

    func testContextKeepsTheParentFrame() {
        let frame = CGRect(x: 8, y: 12, width: 20, height: 24)
        let presented = Presented.context(item: "A", parentFrame: frame, blurRadius: 3, background: AnyView(Color.clear))

        XCTAssertEqual(presented.parentFrame, frame)
        XCTAssertEqual(presented.blurRadius, 3)
        XCTAssertEqual(Presented.sheet(item: "A").blurRadius, 0)
        XCTAssertNil(Presented.sheet(item: "A").parentFrame)
    }
}
