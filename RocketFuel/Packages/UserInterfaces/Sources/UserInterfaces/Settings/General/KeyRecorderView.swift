//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Carbon
import HotKeys
import SwiftUI

struct KeyRecorderView: View {
    
    var body: some View {
        ZStack(alignment: .trailing) {
            field.onKeyDown { event in
                guard case .recording = state else {
                    return
                }
                
                handle(event: event)
            }
        }.onAppear(perform: didAppear)
    }
    
    @ViewBuilder
    private var field: some View {
        Button {
            state = .recording
        } label: {
            HStack {
                Spacer()
                Text(state.text)
                    .font(.body)
                    .foregroundColor(state.foregroundColor)
                Spacer()
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.borderless)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.white.opacity(0.6), lineWidth: 1)
        )
        
        if case .recorded = state {
            ClearButton(action: clear)
                .padding(.trailing, 8)
        }
    }
    
    private let settings: Settings
    @SwiftUI.State private var state: State = .clear
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    private func didAppear() {
        Task {
            guard let hotKey = await settings.registeredHotKey else {
                return
            }
            
            state = .recorded(hotKey: hotKey)
        }
    }
    
    private func handle(event: NSEvent) {
        guard var character = event.readableCharacter else {
            state = .clear
            return
        }
        
        let keyCode = Int(event.keyCode)
        var modifier = 0
        
        if event.modifierFlags.contains(.command) {
            character = "⌘\(character)"
            modifier |= cmdKey
        }
        
        if event.modifierFlags.contains(.option) {
            character = "⌥\(character)"
            modifier |= optionKey
        }
        
        if event.modifierFlags.contains(.shift) {
            character = "⇧\(character)"
            modifier |= shiftKey
        }
        
        if event.modifierFlags.contains(.control) {
            character = "^\(character)"
            modifier |= controlKey
        }
        
        do {
            let hotKey = HotKey(keyCode: keyCode, modifier: modifier, readable: character, action: nil)
            try HotKeysCentral.standard.register(hotKey)
            state = .recorded(hotKey: hotKey)
            
            Task {
                await settings.setRegisteredHotKey(to: hotKey)
            }
        } catch {
            print("An error occurred, could not register hot key: \(error.localizedDescription)")
            state = .error
        }
    }
    
    private func clear() {
        guard case .recorded(let hotKey) = state else {
            return
        }
        
        do {
            try HotKeysCentral.standard.unregister(hotKey)
            state = .clear
            
            Task {
                await settings.setRegisteredHotKey(to: nil)
            }
        } catch {
            print("An error occurred, could not unregister hot key: \(error.localizedDescription)")
            state = .error
        }
    }
}

extension KeyRecorderView {
    private enum State {
        case clear
        case error
        case recording
        case recorded(hotKey: HotKey)
        
        var text: String {
            switch self {
            case .clear:
                return "Record Shortcut"
            case .error:
                return "Try Again..."
            case .recording:
                return "Type Shortcut..."
            case .recorded(let hotKey):
                return hotKey.readable
            }
        }
        
        var foregroundColor: Color {
            guard case .recorded = self else {
                return .gray
            }
            
            return .white
        }
    }
}
