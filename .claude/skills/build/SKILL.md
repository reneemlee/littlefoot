---
name: build
description: Regenerate Xcode project and build Little Foot for iOS Simulator
disable-model-invocation: true
---

# Build Little Foot

Regenerate the Xcode project from `project.yml` and build for the iOS Simulator.

## Process

1. Run XcodeGen to regenerate the project:
```bash
cd /Users/reneelee/littlefoot && xcodegen generate
```

2. Build for iOS Simulator:
```bash
cd /Users/reneelee/littlefoot && xcodebuild -scheme LittleFoot -destination 'platform=iOS Simulator,name=iPhone 16' build 2>&1 | tail -20
```

3. If the build fails, read the error output and fix the issues. Common problems:
   - Missing file references: check `project.yml` sources
   - Swift compilation errors: check the file and line referenced
   - Missing assets: verify image names in `Assets.xcassets`

4. Report build result (success or failure with details).
