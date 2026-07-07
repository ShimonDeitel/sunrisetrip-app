import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [Sighting] = []
    @Published var isPro: Bool = false

    /// Free-tier cap. Must stay above the seed-data count so a fresh install
    /// never hits the paywall immediately.
    static let freeLimit = 8

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("sunrisetracker_items.json")
    }()

    init() {
        load()
        if items.isEmpty {
            seed()
        }
    }

    private func seed() {
        items = [
            Sighting(title: "Haleakala Summit", value2: "Sunrise, incredible clouds"),
            Sighting(title: "Santorini Cliffs", value2: "Sunset over the caldera")
        ]
        save()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([Sighting].self, from: data) {
            items = decoded
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    @discardableResult
    func add(_ item: Sighting) -> Bool {
        guard canAddMore else { return false }
        items.insert(item, at: 0)
        save()
        return true
    }

    func update(_ item: Sighting) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Sighting) {
        items.removeAll(where: { $0.id == item.id })
        save()
    }
}
