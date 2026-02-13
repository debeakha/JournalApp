# Build Your First iPhone App: Journal App Tutorial

*A beginner-friendly guide to building iOS apps using SwiftUI*

---

## What is "Vibe Coding"?

Vibe coding means building apps by focusing on what you want the app to **feel like** and **do**, rather than getting stuck in technical details. You'll learn just enough to:
- Understand the app structure
- Make changes confidently
- Build and run your creation

---

## Part 1: The Tools You Need

### What is Xcode?
Xcode is Apple's app-building software (like a fancy text editor + preview tool combined). It comes free from the Mac App Store.

### What is SwiftUI?
SwiftUI is Apple's modern way to build iPhone user interfaces. Instead of drawing each pixel, you describe *what* you want, and SwiftUI figures out how to draw it.

### What is XcodeGen?
XcodeGen is a tool that creates the Xcode project files automatically. Instead of manually configuring settings, you just write a simple configuration file (`project.yml`) and it generates everything.

---

## Part 2: Understanding Your App's Structure

Think of your app like a small town:

```
JournalApp/
├── App/                    # City Hall (app entry point)
│   └── JournalAppApp.swift
├── Models/                 # blueprints (data structures)
│   └── JournalEntry.swift
├── ViewModels/             # town council (business logic)
│   └── JournalStore.swift
├── Views/                 # buildings (what user sees)
│   ├── JournalListView.swift
│   └── JournalEditorView.swift
└── Resources/             # decorations (icons, colors)
    └── Assets.xcassets/
```

### Each File Explained

#### 1. `JournalAppApp.swift` - The Starting Point
```swift
import SwiftUI

@main
struct JournalAppApp: App {
    var body: some Scene {
        WindowGroup {
            JournalListView()
        }
    }
}
```

**What it does:** This is the app's front door. When you open the app, this file runs first and shows `JournalListView`.

- `@main` = "this is where the app starts"
- `WindowGroup` = "show this to the user"

---

#### 2. `JournalEntry.swift` - The Blueprint
```swift
struct JournalEntry: Identifiable, Codable, Equatable {
    let id: UUID           // unique ID for each entry
    var title: String      // entry title
    var content: String    // entry text
    let createdAt: Date    // when created
    var updatedAt: Date    // last modified
}
```

**What it does:** Defines what a journal entry looks like. It's like a form template:

| Field | What it stores |
|-------|---------------|
| id | Unique identifier (like a fingerprint) |
| title | The heading of your entry |
| content | The main text |
| createdAt | Date/time created |
| updatedAt | Date/time last edited |

---

#### 3. `JournalStore.swift` - The Brain
```swift
@MainActor
class JournalStore: ObservableObject {
    @Published var entries: [JournalEntry] = []
    
    // Load from phone storage
    private func loadEntries() { ... }
    
    // Save to phone storage  
    private func saveEntries() { ... }
    
    // Add new entry
    func addEntry(title: String, content: String) { ... }
    
    // Update existing entry
    func updateEntry(_ entry: JournalEntry, title: String, content: String) { ... }
    
    // Delete entry
    func deleteEntry(_ entry: JournalEntry) { ... }
}
```

**What it does:** Manages all your data. It:
- Stores entries in a list (`[JournalEntry]`)
- Saves to phone memory (`UserDefaults`)
- Provides functions to add/edit/delete entries

The `@Published` keyword means "when this changes, update the screen automatically."

---

#### 4. `JournalListView.swift` - The Main Screen
```swift
struct JournalListView: View {
    @StateObject private var store = JournalStore()
    @State private var showingEditor = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "1A1A2E")  // dark background
                
                if store.entries.isEmpty {
                    // Show this when no entries
                    emptyState
                } else {
                    // Show this when there are entries
                    entryList
                }
                
                // Floating + button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        addButton
                    }
                }
            }
        }
    }
}
```

**What it does:** Displays the main screen with:
- Dark background color
- List of journal entries (or empty state)
- Floating "+" button to add new entries

---

#### 5. `JournalEditorView.swift` - The Edit Screen
```swift
struct JournalEditorView: View {
    @State private var title: String = ""
    @State private var content: String = ""
    let entry: JournalEntry?  // nil = new entry, has value = editing
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Title your entry...", text: $title)
                TextEditor(text: $content)
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { saveEntry() }
                    .disabled(!isValid)
            }
        }
    }
}
```

**What it does:** The screen for creating/editing entries with:
- Title text field
- Content text editor
- Cancel and Save buttons
- Validation (can't save without title)

---

## Part 3: Understanding Key Concepts

### 1. `@State` vs `@StateObject` vs `@ObservedObject`

| Keyword | When to use |
|---------|-------------|
| `@State` | Simple data that changes within one view |
| `@StateObject` | Create a new ObservableObject (like JournalStore) |
| `@ObservedObject` | Use an existing ObservableObject passed to this view |

**Simple rule:** 
- Use `@StateObject` in the view that *creates* the data store
- Use `@ObservedObject` in views that *receive* the data store

---

### 2. `@Binding` - Two-Way Connection

When you write `text: $title`, the `$` creates a "binding" - changes in the text field update the variable, and changes to the variable update the text field.

---

### 3. Navigation in SwiftUI

```swift
// Present a sheet (modal)
.sheet(isPresented: $showingEditor) {
    JournalEditorView()
}

// Present a detail view
NavigationLink(destination: DetailView()) {
    RowView()
}
```

---

### 4. Styling with Colors

```swift
// Using hex colors
Color(hex: "E94560")  // coral red

// Using system colors
Color.white
Color.gray
Color.red
```

---

## Part 4: How to Make Changes

### Want to change the colors?

Edit `JournalListView.swift` - find `Color(hex: "...")` and change the hex code:

| Color | Hex Code |
|-------|----------|
| Dark Navy | 1A1A2E |
| Deep Blue | 16213E |
| Coral Red | E94560 |
| White | FFFFFF |
| Gray | A0A0A0 |
| Navy Blue | 0F3460 |

### Want to add a new field?

1. Add to `JournalEntry.swift`:
```swift
var mood: String = "happy"  // new field
```

2. Update `JournalEditorView.swift` to show a mood picker

3. Update `JournalStore.swift` to save/load the mood

### Want to change the app name?

Edit `project.yml`:
```yaml
settings:
  base:
    PRODUCT_BUNDLE_IDENTIFIER: com.yourname.journal
```

Then regenerate the project:
```bash
xcodegen generate
```

---

## Part 5: Workflow for Building Apps

### Step 1: Plan What You Want
Write down:
- What screens do you need?
- What data do you- How need to store?
 should it look?

### Step 2: Create the Model
Define your data structures first (like `JournalEntry`).

### Step 3: Create the Store
Build the logic to manage data (like `JournalStore`).

### Step 4: Build the Views
Create each screen using SwiftUI.

### Step 5: Test and Iterate
Build and run, see what works, improve.

---

## Part 6: Common Commands

### Generate Xcode project
```bash
xcodegen generate
```

### Build the app
```bash
xcodebuild -project JournalApp.xcodeproj -scheme JournalApp -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 16e' build
```

### Run on simulator
In Xcode: Press `Cmd + R`

---

## Part 7: Quick Reference - SwiftUI Basics

### Text
```swift
Text("Hello")
    .font(.title)
    .foregroundColor(.white)
```

### Button
```swift
Button(action: {
    // what happens when tapped
}) {
    Text("Tap Me")
}
```

### TextField
```swift
TextField("Placeholder", text: $variable)
```

### Image
```swift
Image(systemName: "plus.circle.fill")
    .font(.system(size: 56))
```

### List
```swift
List {
    ForEach(items) { item in
        RowView(item: item)
    }
}
```

### VStack / HStack (arranging items)
```swift
VStack {      // Vertical stack (top to bottom)
    Text("A")
    Text("B")
}

HStack {      // Horizontal stack (left to right)
    Text("A")
    Text("B")
}
```

---

## What's Next?

Try these challenges:

1. **Add a date display** to show when each entry was created
2. **Add a mood selector** with emoji (😊 😐 😢 😡)
3. **Add search** to filter entries
4. **Add categories** (Work, Personal, Ideas)
5. **Change the theme** to light mode

---

## Troubleshooting

**App won't build?**
- Check for typos in Swift files
- Make sure all files are in the correct folder
- Try: `xcodegen generate` again

**Simulator not showing?**
- Open Xcode first
- Select a simulator from the dropdown
- Press Cmd+R

**Changes not appearing?**
- Stop the app (Cmd+Q)
- Rebuild (Cmd+R)

---

## Summary

You now understand:

- **Model** = Data structure (what information to store)
- **ViewModel** = Logic (how to manage the data)
- **View** = UI (what the user sees)
- **SwiftUI** = The language for building iOS interfaces
- **XcodeGen** = Tool to generate Xcode projects

Congratulations! You've built your first iPhone app! 🎉

Now go forth and vibe code!
