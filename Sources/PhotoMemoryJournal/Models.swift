import Foundation
import SwiftData
import SwiftUI

@Model
final class Memory {
    var id: UUID
    var title: String
    var story: String
    var emoji: String
    var tags: [String]
    var date: Date
    
    var color: Color {
        let colors: [Color] = [.blue, .purple, .pink, .orange, .green, .red]
        let index = abs(id.hashValue) % colors.count
        return colors[index]
    }
    
    init(title: String, story: String, emoji: String, tags: [String]) {
        self.id = UUID()
        self.title = title
        self.story = story
        self.emoji = emoji
        self.tags = tags
        self.date = Date()
    }
}
