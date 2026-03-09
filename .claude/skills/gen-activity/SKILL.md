---
name: gen-activity
description: Generate new Activity entries matching the project's data format for Little Foot
disable-model-invocation: true
---

# Generate Activity

Create properly formatted Activity entries for the Little Foot app.

## Input

The user provides:
- **Day number(s)** — which day(s) of baby's first year
- **Activity idea** — a brief description or theme

## Process

1. Read the existing activity file for the target day range to match style:
   - Days 1-30: `LittleFoot/Data/Activities_001_030.swift`
   - Days 31-90: `LittleFoot/Data/Activities_031_090.swift`
   - Days 91-180: `LittleFoot/Data/Activities_091_180.swift`
   - Days 181-270: `LittleFoot/Data/Activities_181_270.swift`
   - Days 271-365: `LittleFoot/Data/Activities_271_365.swift`

2. Check `LittleFoot/Assets.xcassets` for available doodle image names.

3. Generate the Activity entry in this exact format:
```swift
// Day N
Activity(
    name: "Short Engaging Title",
    description: "2-3 sentences. Describe what to do, why it matters for development, and a tip. Written warmly for new parents.",
    accessories: ["item1", "item2"],  // or [] if none
    doodle: "existingDoodleName"
),
```

## Style Guidelines

- **name**: Short, action-oriented (2-5 words). Capitalize each word.
- **description**: Warm, encouraging tone. Include developmental context. 2-3 sentences max.
- **accessories**: Only list items parents would need beyond the baby. Use lowercase. Empty array `[]` if nothing extra needed.
- **doodle**: Must match an existing asset. Check the asset catalog first.

## Output

Present the generated entry to the user for review. Only insert into the file after approval.
