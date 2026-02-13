# JournalApp - Specification Document

## 1. Project Overview

- **Project Name**: JournalApp
- **Bundle Identifier**: com.journalapp.app
- **Core Functionality**: A modern iOS journal app that allows users to create, read, update, and delete journal entries with local persistence
- **Target Users**: Anyone who wants to keep a personal journal on their iPhone
- **iOS Version Support**: iOS 17.0+

## 2. UI/UX Specification

### Screen Structure
1. **JournalListView** - Main screen showing all journal entries
2. **JournalEditorView** - Screen for creating/editing journal entries
3. **Navigation**: NavigationStack with push navigation

### Navigation Flow
```
JournalListView (Root)
    └── JournalEditorView (Push)
            └── (Back to List)
```

### Visual Design

#### Color Palette
- **Primary**: #1A1A2E (Dark Navy) - Main background
- **Secondary**: #16213E (Deep Blue) - Card backgrounds
- **Accent**: #E94560 (Coral Red) - Action buttons, highlights
- **Text Primary**: #FFFFFF (White)
- **Text Secondary**: #A0A0A0 (Gray)
- **Surface**: #0F3460 (Navy Blue) - Input fields

#### Typography
- **Title Large**: System Bold, 34pt (Screen titles)
- **Title Medium**: System Semibold, 22pt (Entry titles)
- **Body**: System Regular, 17pt (Entry content)
- **Caption**: System Regular, 13pt (Timestamps, metadata)

#### Spacing System (8pt Grid)
- **XS**: 4pt
- **SM**: 8pt
- **MD**: 16pt
- **LG**: 24pt
- **XL**: 32pt

### Views & Components

#### JournalListView
- **NavigationStack** with title "My Journal"
- **Floating Action Button (FAB)** in bottom-right to add new entry
- **List** of journal entry cards with:
  - Entry title (truncated to 1 line)
  - Entry preview (truncated to 2 lines)
  - Timestamp (formatted: "Jan 15, 2026")
- **Empty State**: Centered illustration with "Start your journey" message
- **Swipe Actions**: Delete (red) on each entry

#### JournalEditorView
- **NavigationStack** with title "New Entry" or "Edit Entry"
- **Cancel** button (left) - discards changes
- **Save** button (right) - saves entry (disabled if title empty)
- **Title TextField** - Placeholder: "Title your entry..."
- **Content TextEditor** - Multi-line, placeholder: "Write your thoughts..."
- **Date Display** - Shows current date/time (read-only)

#### Interactive Behaviors
- **List**: Pull-to-refresh (optional), swipe-to-delete with confirmation
- **Editor**: Keyboard avoidance, auto-save draft (optional)
- **Transitions**: Standard iOS push/pop animations

## 3. Functionality Specification

### Core Features
1. **Create Journal Entry**
   - User taps FAB → navigates to editor
   - User enters title and content
   - User taps Save → entry saved with timestamp

2. **View Journal Entries**
   - List sorted by date (newest first)
   - Shows title, preview (first 100 chars), timestamp

3. **Edit Journal Entry**
   - User taps entry → navigates to editor with pre-filled data
   - User modifies and saves

4. **Delete Journal Entry**
   - Swipe left on entry → Delete button appears
   - Tap Delete → confirmation alert → entry removed

### Data Handling
- **Persistence**: UserDefaults (JSON encoded array of entries)
- **Data Model**: JournalEntry (Codable)
  - id: UUID
  - title: String
  - content: String
  - createdAt: Date
  - updatedAt: Date

### Architecture Pattern
- **MVVM** (Model-View-ViewModel)
  - Model: JournalEntry
  - ViewModel: JournalStore (ObservableObject)
  - Views: SwiftUI Views

### Edge Cases & Error Handling
- Empty title: Disable Save button
- Empty content: Allowed (user might add later)
- No entries: Show empty state
- Save failure: Show alert with retry option

## 4. Technical Specification

### Dependencies
- None required (using native SwiftUI + Foundation)

### UI Framework
- **SwiftUI** (iOS 17+)

### Asset Requirements
- **App Icon**: Default (can be customized later)
- **SF Symbols Used**:
  - plus.circle.fill (FAB)
  - trash.fill (Delete action)
  - book.fill (Empty state)
  - pencil (Edit indicator - optional)

### Project Structure
```
JournalApp/
├── App/
│   └── JournalAppApp.swift
├── Models/
│   └── JournalEntry.swift
├── ViewModels/
│   └── JournalStore.swift
├── Views/
│   ├── JournalListView.swift
│   └── JournalEditorView.swift
├── Resources/
│   └── Assets.xcassets/
└── Info.plist
```
