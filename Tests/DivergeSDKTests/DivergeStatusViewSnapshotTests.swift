import SnapshotTesting
import XCTest
@_spi(Testing) import DivergeSDK
import DivergeSDKUI

/// Text dumps stay stable across macOS/`swift test` and iOS Simulator CI.
final class DivergeStatusViewSnapshotTests: XCTestCase {
    override func tearDown() {
        Diverge.reset()
        super.tearDown()
    }

    func testStatusViewNotConfiguredDump() {
        let dump = DivergeStatusView.accessibilityDump(client: nil)
        XCTAssertTrue(dump.contains("title: Diverge SDK"))
        XCTAssertTrue(dump.contains("version: \(Diverge.version)"))
        XCTAssertTrue(dump.contains("state: not-configured"))
        assertSnapshot(of: dump, as: .lines)
    }

    func testStatusViewConfiguredSandboxDump() throws {
        let client = try Diverge.configure(
            Configuration(apiKey: "sk_test_snapshot", environment: .sandbox)
        )
        let dump = DivergeStatusView.accessibilityDump(client: client)
        XCTAssertTrue(dump.contains("environment: sandbox"))
        XCTAssertTrue(dump.contains("apiBaseURL: https://sandbox.api.askdiverge.ai"))
        XCTAssertFalse(dump.contains("sk_test_snapshot"), "API key must not appear in a11y dump")
        assertSnapshot(of: dump, as: .lines)
    }

    func testStatusViewAccessibilityLabelsArePresentInViewHierarchy() {
        // Contract for VoiceOver: header + version labels always exist; configured adds env + URL.
        let dump = DivergeStatusView.accessibilityDump(client: nil)
        XCTAssertEqual(
            dump.split(separator: "\n").count,
            3,
            "Not-configured dump should expose title, version, and state"
        )
    }
}
