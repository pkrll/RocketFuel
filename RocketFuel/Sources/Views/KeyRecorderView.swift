//
//  Copyright © 2025 Ardalan Samimi. All rights reserved.
//

import Carbon
import SwiftUI

struct KeyRecorderView: View {
    @Environment(AppState.self) private var appState
    @State private var state: RecordingState = .idle
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            recordButton
            if appState.hotKey != nil {
                clearButton
            }
        }
        .onAppear {
            if appState.hotKey != nil {
                state = .recorded
            }
        }
    }

    private var recordButton: some View {
        Button {
            state = .recording
            isFocused = true
        } label: {
            HStack {
                Spacer()
                Text(buttonText)
                    .foregroundStyle(state == .recorded ? .primary : .secondary)
                Spacer()
            }
            .padding(.vertical, 6)
        }
        .buttonStyle(.bordered)
        .focused($isFocused)
        .onKeyPress { press in
            handleKeyPress(press)
        }
        .onChange(of: isFocused) { _, newValue in
            if !newValue && state == .recording {
                state = appState.hotKey != nil ? .recorded : .idle
            }
        }
    }

    private var clearButton: some View {
        Button {
            appState.setHotKey(nil)
            state = .idle
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
    }

    private var buttonText: String {
        switch state {
        case .idle:
            return "Record Shortcut"
        case .recording:
            return "Press keys..."
        case .recorded:
            return appState.hotKey?.readable ?? "Record Shortcut"
        case .error:
            return "Try again..."
        }
    }

    private func handleKeyPress(_ press: KeyPress) -> KeyPress.Result {
        guard state == .recording else { return .ignored }

        // Require at least one modifier
        guard !press.modifiers.isEmpty else { return .handled }

        // Ignore modifier-only presses
        let modifierOnlyKeys: Set<KeyEquivalent> = [
            KeyEquivalent(Character(UnicodeScalar(0)!))
        ]
        if modifierOnlyKeys.contains(press.key) { return .handled }

        let keyCode = Int(press.key.character.asciiValue ?? 0)
        var modifier = 0
        var readable = ""

        if press.modifiers.contains(.control) {
            readable += "^"
            modifier |= controlKey
        }
        if press.modifiers.contains(.option) {
            readable += "⌥"
            modifier |= optionKey
        }
        if press.modifiers.contains(.shift) {
            readable += "⇧"
            modifier |= shiftKey
        }
        if press.modifiers.contains(.command) {
            readable += "⌘"
            modifier |= cmdKey
        }

        readable += String(press.key.character).uppercased()

        // We need the actual keyCode from the system, not ASCII
        // For now, we'll use a simplified approach
        let hotKey = HotKey(
            keyCode: keyCode,
            modifier: modifier,
            readable: readable
        )

        do {
            appState.setHotKey(hotKey)
            state = .recorded
            isFocused = false
        } catch {
            state = .error
        }

        return .handled
    }
}

// MARK: - Recording State

extension KeyRecorderView {
    enum RecordingState {
        case idle
        case recording
        case recorded
        case error
    }
}

#Preview {
    KeyRecorderView()
        .environment(AppState())
        .padding()
}
