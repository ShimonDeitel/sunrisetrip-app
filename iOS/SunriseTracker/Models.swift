import Foundation

/// A single logged sighting entry.
struct Sighting: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var value2: String
    var notes: String = ""
    var dateAdded: Date = Date()

    init(id: UUID = UUID(), title: String, value2: String, notes: String = "", dateAdded: Date = Date()) {
        self.id = id
        self.title = title
        self.value2 = value2
        self.notes = notes
        self.dateAdded = dateAdded
    }
}
