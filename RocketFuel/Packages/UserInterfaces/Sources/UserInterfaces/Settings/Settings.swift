//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation
import HotKeys
import Combine

public protocol Settings: Actor {
    var registeredHotKey: HotKey? { get }
    var isActive: Bool { get }
    var leftClickActivation: Bool { get }
    var disableOnBatteryMode: Bool { get }
    var disableAtBatteryLevel: Int { get }
    func setRegisteredHotKey(to value: HotKey?)
    func setLeftClickActivation(to value: Bool) async
    func setDisableOnBatteryMode(to value: Bool) async
    func setDisableAtBatteryLevel(to value: Int) async
}
