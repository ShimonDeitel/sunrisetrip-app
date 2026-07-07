import XCTest
@testable import SunriseTracker

@MainActor
final class SunriseTrackerTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.items = []
        store.isPro = false
    }

    func testSeedCountBelowFreeLimit() {
        let fresh = Store()
        XCTAssertLessThan(fresh.items.count, Store.freeLimit)
    }

    func testAddItemIncreasesCount() {
        let before = store.items.count
        let added = store.add(Sighting(title: "Test", value2: "note"))
        XCTAssertTrue(added)
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testCannotAddBeyondFreeLimitWhenNotPro() {
        store.isPro = false
        for i in 0..<Store.freeLimit {
            _ = store.add(Sighting(title: "Item \(i)", value2: "n"))
        }
        let result = store.add(Sighting(title: "Overflow", value2: "n"))
        XCTAssertFalse(result)
        XCTAssertEqual(store.items.count, Store.freeLimit)
    }

    func testProUserCanAddBeyondLimit() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 3) {
            _ = store.add(Sighting(title: "Item \(i)", value2: "n"))
        }
        XCTAssertEqual(store.items.count, Store.freeLimit + 3)
    }

    func testDeleteRemovesItem() {
        let item = Sighting(title: "ToDelete", value2: "n")
        _ = store.add(item)
        XCTAssertTrue(store.items.contains(item))
        store.delete(item)
        XCTAssertFalse(store.items.contains(item))
    }

    func testUpdateModifiesItem() {
        var item = Sighting(title: "Original", value2: "n")
        _ = store.add(item)
        item.title = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first(where: { $0.id == item.id })?.title, "Updated")
    }

    func testDeleteAtOffsets() {
        _ = store.add(Sighting(title: "A", value2: "n"))
        _ = store.add(Sighting(title: "B", value2: "n"))
        let count = store.items.count
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, count - 1)
    }

    func testPersistenceRoundTrip() {
        _ = store.add(Sighting(title: "Persisted", value2: "n"))
        store.save()
        let reloaded = Store()
        XCTAssertTrue(reloaded.items.contains(where: { $0.title == "Persisted" }))
    }
}
