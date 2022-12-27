//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Analytics
import Cocoa
import CrashReporting
import MenuBarExtras

extension Menu {
    func insertDeveloperSettingsMenu(appState: AppState, analytics: Analytics, crashReporter: CrashReporter) async {
        let title = "Developer Settings"
        let loggingIsEnabled = appState._shouldTrackEvents
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        
        let menu = Menu(title: title) {
            Menu.Item.button(title: "Analytics", children: [
                .button(title: "\(loggingIsEnabled ? "Disable" : "Enable") Logging") {
                    analytics.enableEventsTracking(!loggingIsEnabled)
                },
                .button(title: "Log Developer Test Event") {
                    analytics.track(.developerSettingsTest, sendImmediately: true)
                },
            ])
            
            Menu.Item.separator
            Menu.Item.button(title: "Crash") {
                crashReporter.crash()
            }
        }
        
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        item.submenu = menu
        
        let lastIndex = items.count - 1
        insertItem(item, at: lastIndex)
    }
}
