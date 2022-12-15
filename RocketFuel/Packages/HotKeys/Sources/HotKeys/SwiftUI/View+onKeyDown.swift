//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import SwiftUI

struct KeyEventHandler: ViewModifier {
    
    private let eventCallback: (NSEvent) -> Void
    
    func body(content: Content) -> some View {
        content
            .background(KeyRecorderView(eventCallback: eventCallback))
    }
    
    init(eventCallback: @escaping (NSEvent) -> Void) {
        self.eventCallback = eventCallback
    }
}

extension View {
    public func onKeyDown(_ callback: @escaping (NSEvent) -> Void) -> some View {
        modifier(KeyEventHandler(eventCallback: callback))
    }
}

