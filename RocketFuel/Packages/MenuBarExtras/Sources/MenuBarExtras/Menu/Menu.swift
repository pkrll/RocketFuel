//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Cocoa

public final class Menu: NSMenu {
    
    private var options: [Item] = []
    
    public convenience init(title: String, items: [Item]) {
        self.init(title: title)
        configure(with: items)
    }
    
    private func configure(with items: [Item]) {
        self.items = items.map { item in
            let menuItem: NSMenuItem
            
            switch item {
            case .button(let title, let selected, let keyEquivalent, let children, let action):
                menuItem = NSMenuItem(title: title, action: nil, keyEquivalent: keyEquivalent)
                menuItem.state = selected ? .on : .off
                menuItem.target = self
                menuItem.action = action != nil ? #selector(didSelectMenuItem(_:)) : nil
                
                if let children {
                    menuItem.submenu = Menu(title: title, items: children)
                }
            case .separator:
                menuItem = .separator()
            }
            
            menuItem.tag = options.count
            options.append(item)
            return menuItem
        }
    }
    
    @objc
    private func didSelectMenuItem(_ sender: NSMenuItem?) {
        guard let sender else {
            return
        }
        
        let option = options[sender.tag]
        switch option {
        case .button(_, _, _, _, let action):
            action?()
        case .separator:
            break
        }
    }
}
