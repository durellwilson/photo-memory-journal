# 📸 Photo Memory Journal

Learn SwiftUI Layouts + SwiftData by building a beautiful memory journal!

## 🎯 What You'll Learn

### SwiftUI Layouts
- ✅ LazyVGrid for photo grid
- ✅ Custom FlowLayout
- ✅ Adaptive columns
- ✅ ScrollView composition

### SwiftData
- ✅ Array properties
- ✅ Computed properties
- ✅ Color from UUID

### UI Patterns
- ✅ Card-based design
- ✅ Sheet presentations
- ✅ Tag management
- ✅ Emoji selection

## 🚀 Features

- Beautiful photo grid
- Add memories with emojis
- Write stories
- Tag memories
- Detail view
- Color-coded cards

## 📖 Step-by-Step Tutorial

### Step 1: Model (5 min)
```swift
@Model
final class Memory {
    var title: String
    var story: String
    var emoji: String
    var tags: [String]
}
```

**Learn**: Arrays in SwiftData

### Step 2: Grid Layout (15 min)
```swift
LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
    ForEach(memories) { memory in
        MemoryCard(memory: memory)
    }
}
```

**Learn**: Adaptive grid layouts

### Step 3: FlowLayout (20 min)
```swift
struct FlowLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews) -> CGSize {
        // Calculate flow layout
    }
}
```

**Learn**: Custom Layout protocol

### Step 4: Tag System (10 min)
```swift
@State private var tags: [String] = []

HStack {
    TextField("Add tag", text: $newTag)
    Button("Add") {
        tags.append(newTag)
    }
}
```

**Learn**: Dynamic arrays

**Total Time**: 50 minutes

## 🎨 Customization Ideas

### Beginner
- Add more emojis
- Change grid columns
- Add animations

### Intermediate
- PhotosPicker integration
- Search by tags
- Export memories

### Advanced
- Vision for auto-tags
- CloudKit sync
- Share memories

## 🏆 Challenge

Build these features:
1. 📅 Calendar view
2. 🔍 Search memories
3. 📸 Real photos
4. 🎨 Custom themes
5. 📤 Share as PDF

## 📚 Concepts Covered

- LazyVGrid and adaptive columns
- Custom Layout protocol
- Array manipulation
- Sheet presentations
- Tag management
- Computed properties
- Color generation

## 💡 Real-World Applications

This pattern works for:
- Photo albums
- Recipe collections
- Travel journals
- Project portfolios
- Product catalogs

## 🎓 Next Steps

After completing this:
- Try [AI Recipe Generator](../ai-recipe-generator)
- Build [Mood Tracker](../mood-tracker)
- Create your own journal!

---

**Capture memories. Tell stories.** 📸
