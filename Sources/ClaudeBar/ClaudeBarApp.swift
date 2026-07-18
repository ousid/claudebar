import SwiftUI

@main
struct ClaudeBarApp: App {
    @StateObject private var model = UsageModel()

    var body: some Scene {
        MenuBarExtra {
            MenuView(model: model)
        } label: {
            MenuBarLabel(model: model)
        }
        .menuBarExtraStyle(.window)
    }
}

struct MenuBarLabel: View {
    @ObservedObject var model: UsageModel

    var body: some View {
        if let max = model.highestUtilization {
            Text("✳ \(Int(max.rounded()))%")
        } else {
            Text(model.connected ? "✳" : "✳ –")
        }
    }
}
