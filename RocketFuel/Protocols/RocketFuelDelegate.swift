//
//  RocketFuelDelegate.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 23/12/15.
//  Copyright © 2015 Ardalan Samimi. All rights reserved.
//

import Foundation

protocol RocketFuelDelegate {
    func rocketFuel(rocketFuel: RocketFuel, didChangeStatus mode: Bool)
}