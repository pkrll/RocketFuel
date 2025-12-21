//
//  Copyright © 2025 Ardalan Samimi. All rights reserved.
//

import Carbon
import SwiftUI

struct KeyRecorderView: View {

    @Environment(AppState.self) private var appState
    @State private var isRecording = false
    @State private var error: String?

    var body: some View {
        VStack {
            HStack {
                ZStack {
                    recordingField
                    recordButton
                }

                if appState.hotKey != nil {
                    clearButton
                }
            }

            if let error {
                Text("Could not set hot key: \(error.localizedLowercase)")
                    .font(.callout)
                    .foregroundStyle(Color.red)
            }
        }
    }

    @ViewBuilder
    private var recordButton: some View {
        Button {
            isRecording = true
        } label: {
            HStack {
                Spacer()
                Text(buttonLabel)
                    .foregroundStyle(appState.hotKey != nil ? .primary : .secondary)
                Spacer()
            }
            .padding(.vertical, 6)
        }
        .buttonStyle(.bordered)
        .opacity(isRecording ? 0 : 1)
    }

    @ViewBuilder
    private var recordingField: some View {
        if isRecording {
            KeyEventView { event in
                handleKeyEvent(event)
            }
            .frame(height: 28)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(.background)
                    .stroke(.blue, lineWidth: 2)
            }
            .overlay {
                Text("Press shortcut...")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var clearButton: some View {
        Button {
            setHotKey(nil)
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
    }

    private var buttonLabel: String {
        if isRecording {
            return "Press shortcut..."
        }
        return appState.hotKey?.readable ?? "Record Shortcut"
    }

    private func setHotKey(_ hotKey: HotKey?) {
        do {
            try appState.setHotKey(hotKey)
        } catch {
            print(error.localizedDescription)
        }
    }

    private func handleKeyEvent(_ event: NSEvent) {
        isRecording = false

        guard let character = event.readableCharacter else { return }

        let keyCode = Int(event.keyCode)
        let isFunctionKey = event.isFunctionKey

        // Require at least one modifier key, unless it's a function key
        let hasModifier = event.modifierFlags.contains(.command) ||
                          event.modifierFlags.contains(.option) ||
                          event.modifierFlags.contains(.control) ||
                          event.modifierFlags.contains(.shift)

        guard hasModifier || isFunctionKey else { return }

        var modifier = 0
        var readable = ""

        if event.modifierFlags.contains(.control) {
            readable += "^"
            modifier |= controlKey
        }
        if event.modifierFlags.contains(.option) {
            readable += "⌥"
            modifier |= optionKey
        }
        if event.modifierFlags.contains(.shift) {
            readable += "⇧"
            modifier |= shiftKey
        }
        if event.modifierFlags.contains(.command) {
            readable += "⌘"
            modifier |= cmdKey
        }

        readable += character.uppercased()

        let hotKey = HotKey(keyCode: keyCode, modifier: modifier, readable: readable)
        setHotKey(hotKey)
    }
}

// MARK: - Key Event Capturing View

private struct KeyEventView: NSViewRepresentable {
    let onKeyDown: (NSEvent) -> Void

    func makeNSView(context: Context) -> KeyListenerView {
        let view = KeyListenerView(onKeyDown: onKeyDown)
        DispatchQueue.main.async {
            view.window?.makeFirstResponder(view)
        }
        return view
    }

    func updateNSView(_ nsView: KeyListenerView, context: Context) {
        DispatchQueue.main.async {
            nsView.window?.makeFirstResponder(nsView)
        }
    }
}

private final class KeyListenerView: NSView {
    private let onKeyDown: (NSEvent) -> Void

    override var acceptsFirstResponder: Bool { true }

    init(onKeyDown: @escaping (NSEvent) -> Void) {
        self.onKeyDown = onKeyDown
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func keyDown(with event: NSEvent) {
        onKeyDown(event)
    }
}

// MARK: - NSEvent Extension

private extension NSEvent {
    var isFunctionKey: Bool {
        let code = Int(keyCode)
        return [
            kVK_F1, kVK_F2, kVK_F3, kVK_F4, kVK_F5, kVK_F6,
            kVK_F7, kVK_F8, kVK_F9, kVK_F10, kVK_F11, kVK_F12
        ].contains(code)
    }

    var readableCharacter: String? {
        let code = Int(keyCode)

        switch code {
        case kVK_F1: return "F1"
        case kVK_F2: return "F2"
        case kVK_F3: return "F3"
        case kVK_F4: return "F4"
        case kVK_F5: return "F5"
        case kVK_F6: return "F6"
        case kVK_F7: return "F7"
        case kVK_F8: return "F8"
        case kVK_F9: return "F9"
        case kVK_F10: return "F10"
        case kVK_F11: return "F11"
        case kVK_F12: return "F12"
        case kVK_Space: return "Space"
        case kVK_Return: return "Return"
        case kVK_Tab: return "Tab"
        case kVK_Delete: return "Delete"
        case kVK_Escape: return "Esc"
        case kVK_LeftArrow: return "←"
        case kVK_RightArrow: return "→"
        case kVK_UpArrow: return "↑"
        case kVK_DownArrow: return "↓"
        default:
            return charactersIgnoringModifiers
        }
    }
}

#Preview {
    KeyRecorderView()
        .environment(AppState())
        .frame(width: 300)
}
