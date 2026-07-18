import SwiftUI

/// Hidden dev flag: `ClaudeBar --screenshot out.png` renders the popover
/// with mock data to a PNG (for the README) and exits. No permissions needed.
@MainActor
enum Screenshot {
    static func runIfRequested() {
        guard let i = CommandLine.arguments.firstIndex(of: "--screenshot"),
              CommandLine.arguments.count > i + 1 else { return }
        let path = CommandLine.arguments[i + 1]

        let model = UsageModel()
        model.connected = true
        let cal = Calendar.current
        model.windows = [
            UsageWindow(id: "five_hour", label: "Session (5h)", utilization: 34,
                        resetsAt: cal.date(byAdding: .hour, value: 3, to: .now)),
            UsageWindow(id: "seven_day", label: "Weekly", utilization: 76,
                        resetsAt: cal.date(byAdding: .day, value: 4, to: .now)),
            UsageWindow(id: "seven_day_opus", label: "Weekly · Opus", utilization: 12,
                        resetsAt: cal.date(byAdding: .day, value: 4, to: .now)),
        ]

        let view = MenuView(model: model)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(24)
            .background(Color(nsColor: .windowBackgroundColor))

        let renderer = ImageRenderer(content: view)
        renderer.scale = 2
        guard let cg = renderer.cgImage else { fputs("render failed\n", stderr); exit(1) }
        let rep = NSBitmapImageRep(cgImage: cg)
        guard let png = rep.representation(using: .png, properties: [:]) else { exit(1) }
        do {
            try png.write(to: URL(fileURLWithPath: path))
            print("wrote \(path)")
            exit(0)
        } catch {
            fputs("write failed: \(error.localizedDescription)\n", stderr)
            exit(1)
        }
    }
}
