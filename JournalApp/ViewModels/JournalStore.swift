import Foundation
import SwiftUI

@MainActor
class JournalStore: ObservableObject {
    @Published var entries: [JournalEntry] = []
    
    private let userDefaultsKey = "journal_entries"
    
    init() {
        loadEntries()
    }
    
    private func loadEntries() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            entries = []
            return
        }
        
        do {
            let decoder = JSONDecoder()
            entries = try decoder.decode([JournalEntry].self, from: data)
            entries.sort { $0.createdAt > $1.createdAt }
        } catch {
            print("Failed to load entries: \(error)")
            entries = []
        }
    }
    
    private func saveEntries() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(entries)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Failed to save entries: \(error)")
        }
    }
    
    func addEntry(title: String, content: String) {
        let entry = JournalEntry(title: title, content: content)
        entries.insert(entry, at: 0)
        saveEntries()
    }
    
    func updateEntry(_ entry: JournalEntry, title: String, content: String) {
        guard let index = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        
        var updatedEntry = entry
        updatedEntry.title = title
        updatedEntry.content = content
        updatedEntry.updatedAt = Date()
        
        entries[index] = updatedEntry
        entries.sort { $0.createdAt > $1.createdAt }
        saveEntries()
    }
    
    func deleteEntry(_ entry: JournalEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    func deleteEntries(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        saveEntries()
    }
}
