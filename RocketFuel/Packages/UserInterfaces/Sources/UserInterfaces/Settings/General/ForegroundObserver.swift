//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import SwiftUI

final class ForegroundObserver: ObservableObject {
    @Published var enteredForeground = true
    private let notificationCenter: NotificationCenter
    
    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
        
        notificationCenter.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: NSApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc func willEnterForeground() {
        enteredForeground.toggle()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
}
