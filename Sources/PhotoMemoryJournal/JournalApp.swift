import SwiftUI
import SwiftData
import PhotosUI

@main
struct JournalApp: App {
    var body: some Scene {
        WindowGroup {
            MemoryGrid()
        }
        .modelContainer(for: Memory.self)
    }
}

struct MemoryGrid: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Memory.date, order: .reverse) private var memories: [Memory]
    @State private var showAddMemory = false
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(memories) { memory in
                        MemoryCard(memory: memory)
                    }
                }
                .padding()
            }
            .navigationTitle("📸 Memories")
            .toolbar {
                Button("Add", systemImage: "plus.circle.fill") {
                    showAddMemory = true
                }
            }
            .sheet(isPresented: $showAddMemory) {
                AddMemoryView()
            }
        }
    }
}

struct MemoryCard: View {
    let memory: Memory
    @State private var showDetail = false
    
    var body: some View {
        Button {
            showDetail = true
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                // Photo placeholder
                RoundedRectangle(cornerRadius: 12)
                    .fill(memory.color.gradient)
                    .frame(height: 150)
                    .overlay {
                        Text(memory.emoji)
                            .font(.system(size: 60))
                    }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(memory.title)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(memory.date, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    if !memory.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 4) {
                                ForEach(memory.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption2)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(.blue.opacity(0.1))
                                        .cornerRadius(4)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showDetail) {
            MemoryDetailView(memory: memory)
        }
    }
}

struct MemoryDetailView: View {
    let memory: Memory
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Photo
                    RoundedRectangle(cornerRadius: 16)
                        .fill(memory.color.gradient)
                        .frame(height: 300)
                        .overlay {
                            Text(memory.emoji)
                                .font(.system(size: 100))
                        }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(memory.title)
                            .font(.title.bold())
                        
                        Text(memory.date, style: .date)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        if !memory.story.isEmpty {
                            Text(memory.story)
                                .font(.body)
                        }
                        
                        if !memory.tags.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Tags")
                                    .font(.headline)
                                
                                FlowLayout(spacing: 8) {
                                    ForEach(memory.tags, id: \.self) { tag in
                                        Text(tag)
                                            .font(.subheadline)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(.blue.opacity(0.1))
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
            }
            .navigationTitle("Memory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") { dismiss() }
            }
        }
    }
}

struct AddMemoryView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var story = ""
    @State private var emoji = "📸"
    @State private var tags: [String] = []
    @State private var newTag = ""
    
    let emojis = ["📸", "🎉", "🌅", "🍕", "✈️", "🎂", "🏖️", "🎨", "🎵", "⚽️"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Photo") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(emojis, id: \.self) { e in
                                Button {
                                    emoji = e
                                } label: {
                                    Text(e)
                                        .font(.system(size: 40))
                                        .padding()
                                        .background(emoji == e ? Color.blue.opacity(0.2) : Color.clear)
                                        .cornerRadius(12)
                                }
                            }
                        }
                    }
                }
                
                Section("Details") {
                    TextField("Title", text: $title)
                    TextField("Tell your story...", text: $story, axis: .vertical)
                        .lineLimit(5...10)
                }
                
                Section("Tags") {
                    HStack {
                        TextField("Add tag", text: $newTag)
                        Button("Add") {
                            if !newTag.isEmpty {
                                tags.append(newTag)
                                newTag = ""
                            }
                        }
                        .disabled(newTag.isEmpty)
                    }
                    
                    if !tags.isEmpty {
                        FlowLayout(spacing: 8) {
                            ForEach(tags, id: \.self) { tag in
                                HStack {
                                    Text(tag)
                                    Button {
                                        tags.removeAll { $0 == tag }
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.blue.opacity(0.1))
                                .cornerRadius(6)
                            }
                        }
                    }
                }
            }
            .navigationTitle("New Memory")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
                        save()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func save() {
        let memory = Memory(title: title, story: story, emoji: emoji, tags: tags)
        context.insert(memory)
        dismiss()
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var frames: [CGRect] = []
        var size: CGSize = .zero
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }
                
                frames.append(CGRect(x: x, y: y, width: size.width, height: size.height))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}
