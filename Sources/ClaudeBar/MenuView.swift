import SwiftUI
import ServiceManagement

struct MenuView: View {
    @ObservedObject var model: UsageModel
    @State private var code = ""
    @State private var launchAtLogin = SMAppService.mainApp.status == .enabled

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if model.connected {
                usage
            } else {
                connect
            }
            Divider().padding(.horizontal, 12)
            footer
        }
        .frame(width: 280)
        .onAppear { Task { await model.refresh() } }
    }

    // MARK: - Connected

    private var usage: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Claude Usage").font(.headline)
                if model.stale {
                    Circle().fill(.secondary).frame(width: 5, height: 5)
                        .help("Couldn't reach Anthropic — showing last known data")
                }
                Spacer()
            }
            if model.windows.isEmpty {
                Text("Loading…").font(.subheadline).foregroundStyle(.secondary)
            }
            ForEach(model.windows) { w in
                VStack(alignment: .leading, spacing: 3) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(w.label).font(.subheadline)
                        Spacer()
                        Text("\(Int(w.utilization.rounded()))%")
                            .font(.subheadline.monospacedDigit().weight(.medium))
                            .foregroundStyle(w.utilization >= 70 ? w.color : .primary)
                    }
                    ProgressView(value: min(w.utilization, 100), total: 100)
                        .tint(w.color)
                        .controlSize(.small)
                    if let reset = w.resetText {
                        Text(reset).font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(12)
    }

    // MARK: - Connect

    private var connect: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Claude Usage").font(.headline)
            Text("Connect your Claude account to see your session and weekly limits.")
                .font(.subheadline).foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            if model.pendingAuth == nil {
                Button("Connect Claude Account") { model.startConnect() }
                    .controlSize(.large)
            } else {
                Text("Approve in your browser, then paste the code:")
                    .font(.caption).foregroundStyle(.secondary)
                HStack {
                    TextField("Paste code", text: $code)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit { submit() }
                    Button("Connect") { submit() }
                        .disabled(code.isEmpty)
                }
            }
            if let err = model.lastError {
                Text(err).font(.caption).foregroundStyle(.red)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(12)
    }

    private func submit() {
        let c = code
        code = ""
        Task { await model.finishConnect(code: c) }
    }

    // MARK: - Footer

    private var footer: some View {
        VStack(alignment: .leading, spacing: 6) {
            Toggle("Launch at login", isOn: $launchAtLogin)
                .font(.caption)
                .toggleStyle(.checkbox)
                .onChange(of: launchAtLogin) { on in
                    try? on ? SMAppService.mainApp.register() : SMAppService.mainApp.unregister()
                }
            HStack(spacing: 12) {
                footerButton("Refresh") { Task { await model.refresh() } }
                footerButton("Dashboard") {
                    NSWorkspace.shared.open(URL(string: "https://claude.ai/settings/usage")!)
                }
                if model.connected {
                    footerButton("Disconnect") { model.disconnect() }
                }
                Spacer()
                footerButton("Quit") { NSApp.terminate(nil) }
            }
        }
        .padding(12)
    }

    private func footerButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
            .buttonStyle(.plain)
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}
