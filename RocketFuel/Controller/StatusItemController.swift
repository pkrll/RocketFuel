//
//  StatusItemController.swift
//  RocketFuel
//
//  Created by Ardalan Samimi on 22/12/15.
//  Copyright © 2015 Ardalan Samimi. All rights reserved.
//
import Cocoa
import ServiceManagement

class StatusItemController: NSObject, NSMenuDelegate {
  /**
   *  The item displayed in the status bar.
   */
  private let statusItem: NSStatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)

  private var aboutWindow: AboutWindowController?
  
  private var willActivateOnLeftClick: Bool {
    get {
      return self.isLeftClickEnabled()
    }
    set (mode) {
      self.enableLeftClickActivation(mode)
    }
  }
  
  private var willLaunchAtLogin: Bool {
    get {
      let defaults = NSUserDefaults.standardUserDefaults()
      let loginAtStart: Bool = defaults.boolForKey("launchAtLogin") ?? false
      
      return loginAtStart
    }
    set (mode) {
      self.applicationShouldLaunchAtLogin(mode)
    }
  }
  
  private lazy var rocketFuel: RocketFuel = {
    let rocketFuel = RocketFuel()
    rocketFuel.delegate = self
    
    return rocketFuel
  }()
  
  private lazy var menu: Menu = {
    [unowned self] in
    let menu = Menu(title: Global.Application.bundleName)
    let action: Selector = #selector(self.didClickMenuItem(_:))
    var item: NSMenuItem?
    
    var state = "Activate Rocket Fuel"
    
    if self.rocketFuel.isActive {
      state = "Deactivate Rocket Fuel"
    }
    
    item = menu.addItemWithTitle(state, action: action, target: self, tag: Global.MenuItem.activate.rawValue)
    
    menu.addItem(NSMenuItem.separatorItem())
    item = menu.addItemWithTitle("Launch at Login", action: action, target: self, tag: Global.MenuItem.autoStart.rawValue, state: Int(self.willLaunchAtLogin))
    item = menu.addItemWithTitle("Deactivate after…", action: nil, target: nil, tag: 0)
    item?.submenu = self.subMenu
    item = menu.addItemWithTitle("Left Click Activation", action: action, target: self, tag: Global.MenuItem.leftClick.rawValue, state: Int(self.willActivateOnLeftClick))
    
    menu.addItem(NSMenuItem.separatorItem())
    item = menu.addItemWithTitle("About Rocket Fuel", action: action, target: self, tag: Global.MenuItem.aboutApp.rawValue)
    
    menu.addItem(NSMenuItem.separatorItem())
    item = menu.addItemWithTitle("Quit", action: #selector(self.terminate), target: self, tag: 0)
    
    menu.delegate = self
    
    return menu
  }()
  
  private lazy var subMenu: Menu = {
    let menu = Menu(title: "Submenu")
    let action: Selector = #selector(self.didClickMenuItem(_:))
    
    menu.addItemWithTitle("5 Minutes", action: action, target: self, tag: 300)
    menu.addItemWithTitle("15 Minutes", action: action, target: self, tag: 900)
    menu.addItemWithTitle("30 Minutes", action: action, target: self, tag: 1800)
    menu.addItemWithTitle("1 Hour", action: action, target: self, tag: 3600)
    menu.addItemWithTitle("Never", action: action, target: self, tag: 0)
    
    return menu
  }()
  
  /**
   *  Indicates whether the application is in an active state.
   *  - Returns: If application is in an active state, that is preventing sleep, this property is true.
   */
  internal var isActive: Bool {
    return self.rocketFuel.isActive
  }
  
  override init() {
    super.init()
    self.didLoad()    
  }
  
  func requestTermination() {
    if self.isActive {
      self.rocketFuel.terminate()
    }
  }
  
  func requestActivation(withDuration: Double = 0) {
    self.rocketFuel.activate(withDuration: withDuration)
  }
  /**
   *  Invoked when the user clicks on the status item.
   *  - Note: Depending on which mouse button, the action should differ.
   */
  func didClickStatusItem(sender: NSStatusBarButton) {
    let click: NSEvent = NSApp.currentEvent!

    if click.type == NSEventType.RightMouseUp || click.modifierFlags.contains(NSEventModifierFlags.CommandKeyMask) || self.willActivateOnLeftClick == false {
      self.statusItem.menu = self.menu
      self.statusItem.popUpStatusItemMenu(self.menu)
    } else {
      self.rocketFuel.toggle()
    }
  }
  
  func didClickMenuItem(sender: NSMenuItem?) {
    guard let sender = sender else {
      return
    }
    
    switch Global.MenuItem(rawValue: sender.tag)! {
      case .activate:
        self.rocketFuel.toggle()
      case .leftClick:
        self.willActivateOnLeftClick = !self.willActivateOnLeftClick
        sender.state = Int(self.willActivateOnLeftClick)
      case .autoStart:
        self.willLaunchAtLogin = !self.willLaunchAtLogin
        sender.state = Int(self.willLaunchAtLogin)
      case .aboutApp:
        self.aboutWindow = AboutWindowController(windowNibName: "About")
        self.aboutWindow?.showWindow(self)
        self.aboutWindow?.window?.makeKeyAndOrderFront(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.aboutWindowWillClose(_:)), name: "aboutWindowWillClose", object: nil)
      default:
        self.rocketFuel.activate(withDuration: Double(sender.tag))
        self.subMenu.resetStateForMenuItems()
        sender.state = NSOnState
    }
  }
  
  func menuDidClose(menu: NSMenu) {
    // IMPORTANT: Fixes the issue where the status bar button would only open the menu once the menu has been assigned to it. By removing the reference the button action is freed up, I guess.
    self.statusItem.menu = nil
  }
  
  func aboutWindowWillClose(sender: AnyObject?) {
    self.aboutWindow = nil
    NSNotificationCenter.defaultCenter().removeObserver(self, name: "aboutWindowWillClose", object: nil)
  }
  
  func terminate() {
    NSApplication.sharedApplication().terminate(self)
  }
  
}

extension StatusItemController: RocketFuelDelegate {
  
  func rocketFuel(rocketFuel: RocketFuel, didChangeStatus mode: Bool) {
    self.statusItem.button!.image = self.statusItemImage(forState: mode)
    let item = self.menu.menuWithTag(Global.MenuItem.activate.rawValue)
    item?.title = (mode == true) ? "Deactivate Rocket Fuel" : "Activate Rocket Fuel"
  }
  
}

private extension StatusItemController {
  /**
   *  Invoked when app is initializing.
   *
   *  Sets up the status item.
   */
  func didLoad() {
    // The bit mask must contain conditions for both right and left click
    let actionMasks = Int((NSEventMask.LeftMouseUpMask).rawValue | (NSEventMask.RightMouseUpMask).rawValue)
    self.statusItem.button!.image = self.statusItemImage()
    self.statusItem.button!.target = self
    self.statusItem.button!.action = #selector(self.didClickStatusItem(_:))
    self.statusItem.button!.sendActionOn(actionMasks)
    self.statusItem.button!.toolTip = "\(Global.Application.bundleName) \(Global.Application.bundleVersion) (\(Global.Application.bundleBuild))"
  }
  /**
   *  Returns the status bar image for the correct state, or for the specified state.
   */
  func statusItemImage(forState state: Bool = true) -> NSImage {
    if self.isActive && state == true {
      return NSImage(named: StatusItemImage.isActive)!
    }
    
    return NSImage(named: StatusItemImage.isIdle)!
  }
  
  // MARK: LEFT CLICK ACTIVATE METHODS
  
  func isLeftClickEnabled() -> Bool {
    let defaults = NSUserDefaults.standardUserDefaults()
    return defaults.boolForKey("leftClickActivation")
  }
  
  func enableLeftClickActivation(state: Bool) {
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setBool(state, forKey: "leftClickActivation")

  }
  
  // MARK: AUTO LAUNCH METHODS
  
  func isApplicationInLoginItems() -> Bool {
    let defaults = NSUserDefaults.standardUserDefaults()
    let loginAtStart: Bool = defaults.boolForKey("launchAtLogin") ?? false

    return loginAtStart
  }
  
  func applicationShouldLaunchAtLogin(mode: Bool) -> Bool {
    let didAddToLoginItems = SMLoginItemSetEnabled("com.ardalansamimi.RocketFuelHelper", mode)
    
    if didAddToLoginItems {
      let defaults = NSUserDefaults.standardUserDefaults()
      defaults.setBool(mode, forKey: "launchAtLogin")
      defaults.synchronize()
    } else {
      let alert = NSAlert()
      alert.messageText = "An error occured. Rocket Fuel could not be added to the login items."
      alert.runModal()
    }
    
    return didAddToLoginItems
  }
  
}
