import SwiftUI

struct JournalListView: View {
    @StateObject private var store = JournalStore()
    @State private var showingEditor = false
    @State private var selectedEntry: JournalEntry?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "1A1A2E")
                    .ignoresSafeArea()
                
                if store.entries.isEmpty {
                    emptyState
                } else {
                    entryList
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        addButton
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .navigationTitle("My Journal")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color(hex: "1A1A2E"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showingEditor) {
                JournalEditorView(store: store, entry: nil)
            }
            .sheet(item: $selectedEntry) { entry in
                JournalEditorView(store: store, entry: entry)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "book.fill")
                .font(.system(size: 64))
                .foregroundColor(Color(hex: "A0A0A0"))
            
            Text("Start your journey")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text("Tap the + button to create your first journal entry")
                .font(.body)
                .foregroundColor(Color(hex: "A0A0A0"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
    
    private var entryList: some View {
        List {
            ForEach(store.entries) { entry in
                JournalEntryRow(entry: entry)
                    .listRowBackground(Color(hex: "16213E"))
                    .listRowSeparatorTint(Color(hex: "0F3460"))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedEntry = entry
                    }
            }
            .onDelete(perform: store.deleteEntries)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    private var addButton: some View {
        Button(action: {
            showingEditor = true
        }) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 56))
                .foregroundColor(Color(hex: "E94560"))
                .shadow(color: Color(hex: "E94560").opacity(0.4), radius: 8, x: 0, y: 4)
        }
    }
}

struct JournalEntryRow: View {
    let entry: JournalEntry
    
    private var formattedDate: String {
        entry.createdAt.formatted(date: .abbreviated, time: .omitted)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text(entry.preview)
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "A0A0A0"))
                .lineLimit(2)
            
            Text(formattedDate)
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "A0A0A0"))
        }
        .padding(.vertical, 8)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    JournalListView()
}
