//
//  Copyright © 2025 Ardalan Samimi. All rights reserved.
//

import Foundation
import CoreGraphics

final class InactivityMonitor: @unchecked Sendable {
    var onInactivityThresholdReached: (() -> Void)?

    private var timer: Timer?
    private var thresholdSeconds: TimeInterval = 0
    private let pollingInterval: TimeInterval = 30

    var isMonitoring: Bool { timer != nil }

    func start(thresholdMinutes: Int) {
        stop()

        guard thresholdMinutes > 0 else { return }

        thresholdSeconds = TimeInterval(thresholdMinutes * 60)

        timer = Timer.scheduledTimer(withTimeInterval: pollingInterval, repeats: true) { [weak self] _ in
            self?.checkIdleTime()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func checkIdleTime() {
        let idleSeconds = CGEventSource.secondsSinceLastEventType(
            .hidSystemState,
            eventType: .mouseMoved
        )

        if idleSeconds >= thresholdSeconds {
            onInactivityThresholdReached?()
            stop()
        }
    }

    deinit {
        stop()
    }
}
