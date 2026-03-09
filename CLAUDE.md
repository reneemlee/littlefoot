# Little Foot

A SwiftUI app that guides parents through their baby's first year with daily activities.

## Build System

This project uses **XcodeGen** — the `.xcodeproj` is generated from `project.yml`. Never edit `.xcodeproj` files directly.

```bash
xcodegen generate  # regenerate after adding files or changing settings
xcodebuild -scheme LittleFoot -destination 'platform=iOS Simulator,name=iPhone 16' build
```

## Architecture

- **SwiftUI** with **SwiftData** for persistence (iOS 17+, Swift 5.9)
- **Models/**: `BabyProfile` and `FavoriteActivity` are `@Model` classes
- **Views/**: SwiftUI views (Dashboard, Favorites, ActivityDetail, Onboarding, Settings)
- **Data/**: 365 activities split across files by day ranges (001-030, 031-090, etc.)
- **Services/**: `NotificationManager` for daily push notifications

## Conventions

### Theme System
All colors and typography go through `Theme.swift`. Use `Theme.primary`, `Theme.background`, etc. — never hardcode colors. Typography uses `.rounded` design throughout.

### Activity Data Format
Activities follow this exact pattern:
```swift
Activity(
    name: "Activity Name",
    description: "Multi-sentence description of the activity.",
    accessories: ["item1", "item2"],  // or [] if none needed
    doodle: "doodleName"             // matches asset catalog image
)
```
Each day gets a `// Day N` comment above its entry. Activities are grouped in files by day range.

### Icons
Uses **PhosphorSwift** library for icons (e.g., `Ph.heart.fill`).

### Dark Mode
Doodle images use the `.doodleStyle(colorScheme)` modifier to invert in dark mode. Theme colors are adaptive via `UIColor { traits in ... }`.
