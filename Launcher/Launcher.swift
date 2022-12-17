//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Cocoa

public final class Launcher: NSObject, NSApplicationDelegate {
    public func applicationDidFinishLaunching(_ aNotification: Notification) {
        defer {
            NSApp.terminate(nil)
        }

        guard let bundleIdentifier = Bundle.main.bundleIdentifier?.replacingOccurrences(of: ".Launcher", with: "") else {
            return
        }
        
        let workspace = NSWorkspace.shared
        var isRunning = false

        for app in workspace.runningApplications {
            guard app.bundleIdentifier == bundleIdentifier else {
                continue
            }

            isRunning = true
            break
        }

        if isRunning {
            return
        }

        var path = Bundle.main.bundlePath as NSString
        for _ in 0...3 {
            path = path.deletingLastPathComponent as NSString
        }

        guard let url = URL(string: "file://\(path)") else {
            return
        }
        
        workspace.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration())
    }
}
