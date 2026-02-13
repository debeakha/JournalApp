import SwiftUI

struct JournalEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: JournalStore
    let entry: JournalEntry?
    
    @State private var title: String = ""
    @State private var content: String = ""
    
    private var isEditing: Bool {
        entry != nil
    }
    
    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var formattedDate: String {
        let date = entry?.createdAt ?? Date()
        return date.formatted(date: .long, time: .shortened)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "1A1A2E")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    titleField
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    
                    Divider()
                        .background(Color(hex: "0F3460"))
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    
                    contentEditor
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                }
            }
            .navigationTitle(isEditing ? "Edit Entry" : "New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(hex: "1A1A2E"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "A0A0A0"))
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                    }
                    .foregroundColor(isValid ? Color(hex: "E94560") : Color(hex: "A0A0A0"))
                    .disabled(!isValid)
                }
            }
        }
        .onAppear {
            if let entry = entry {
                title = entry.title
                content = entry.content
            }
        }
    }
    
    private var titleField: some View {
        TextField("Title your entry...", text: $title)
            .font(.system(size: 22, weight: .semibold))
            .foregroundColor(.white)
            .placeholder(using: Color(hex: "A0A0A0")) {
                Text("Title your entry...")
                    .foregroundColor(Color(hex: "A0A0A0"))
            }
    }
    
    private var contentEditor: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(formattedDate)
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "A0A0A0"))
            
            ZStack(alignment: .topLeading) {
                if content.isEmpty {
                    TextEditor(text: .constant(""))
                        .font(.system(size: 17))
                        .foregroundColor(Color(hex: "A0A0A0"))
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .disabled(true)
                    
                    Text("Write your thoughts...")
                        .font(.system(size: 17))
                        .foregroundColor(Color(hex: "A0A0A0"))
                        .padding(.top, 8)
                        .padding(.leading, 4)
                }
                
                TextEditor(text: $content)
                    .font(.system(size: 17))
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .opacity(content.isEmpty ? 0.01 : 1)
            }
        }
    }
    
    private func saveEntry() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let entry = entry {
            store.updateEntry(entry, title: trimmedTitle, content: trimmedContent)
        } else {
            store.addEntry(title: trimmedTitle, content: trimmedContent)
        }
        
        dismiss()
    }
}

extension View {
    @ViewBuilder
    func placeholder<Content: View>(
        using color: Color,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: .leading) {
            placeholder()
                .opacity(self == nil ? 1 : 0)
            self
        }
    }
}

#Preview {
    JournalEditorView(store: JournalStore(), entry: nil)
}
