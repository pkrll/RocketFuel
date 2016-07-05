//
//  RocketFuelDelegate.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 03/07/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import Foundation

protocol RocketFuelDelegate {
  
  func rocketFuel(_:RocketFuel, didChangeStatus mode: Bool)
  
}