//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import SwiftUI

struct KeyRecorderView: NSViewRepresentable {
    final class ListeningView: NSView {
        override var acceptsFirstResponder: Bool { true }
        private let eventCallback: (NSEvent) -> Void
        
        init(eventCallback: @escaping (NSEvent) -> Void) {
            self.eventCallback = eventCallback
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func keyDown(with event: NSEvent) {
            eventCallback(event)
        }
    }
    
    let eventCallback: (NSEvent) -> Void
    
    func makeNSView(context: Context) -> some NSView {
        let view = ListeningView(eventCallback: eventCallback)
        
        DispatchQueue.main.async {
            view.window?.makeFirstResponder(view)
        }
        
        return view
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        guard let view = nsView as? ListeningView else {
            return
        }
        
        DispatchQueue.main.async {
            view.window?.makeFirstResponder(view)
        }
    }
}
