//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Cocoa

let delegate = Launcher()
NSApplication.shared.delegate = delegate
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
