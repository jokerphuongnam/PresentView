@testable import PresentView
import SwiftUI
import XCTest

@MainActor
final class DismissPresentedTests: XCTestCase {
    func testDismissPopsTheTopEntry() {
        var presented: [Presented<String>] = [
            .sheet(item: "A"),
            .dialog(item: "B"),
        ]
        let dismiss = DismissPresentedActionImpl(Binding(get: { presented }, set: { presented = $0 }))

        XCTAssertTrue(dismiss.canDismiss)
        dismiss(nil)
        XCTAssertEqual(presented.map(\.item), ["A"])
    }

    func testDismissDoesNothingWhenTheStackIsEmpty() {
        var presented: [Presented<String>] = []
        let dismiss = DismissPresentedActionImpl(Binding(get: { presented }, set: { presented = $0 }))

        XCTAssertFalse(dismiss.canDismiss)
        dismiss()
        XCTAssertTrue(presented.isEmpty)
    }
}
