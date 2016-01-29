//
//  StatusBar.swift
//  Meta Clipboard
//
//  Created by Guillermo A Araiza Torres on 28/01/16.
//  Copyright © 2016 Disforma. All rights reserved.
//

import Foundation
import Cocoa

public class StatusBar: NSObject{

    var statusBar       = NSStatusBar.systemStatusBar()
    var statusBarItem   = NSStatusItem()
    var statusBarMenu   = NSMenu()
    
    var menuItemSync  : NSMenuItem = NSMenuItem()
    var menuItemSend  : NSMenuItem = NSMenuItem()
    var menuItemQuit  : NSMenuItem = NSMenuItem()
    
    override init() {
        
        super.init()
        
        //Add statusBarItem
        statusBarItem       = statusBar.statusItemWithLength(-1)
        statusBarItem.menu  = statusBarMenu
        statusBarItem.image = NSImage(named: "StatusBarButtonImage")
        
        // We set the menuItemGet
        menuItemSend.title = "Send to metaclipboard"
        menuItemSend.action = Selector("sendDataToClipboard:")
        menuItemSend.target = self
        menuItemSend.keyEquivalent = "S"
        menuItemSend.enabled = true
        
        // We set the menuItemSend
        menuItemSync.title = "Sync metaclipboard now"
        menuItemSync.action = Selector("updateMetaClipboard:")
        menuItemSync.target = self
        menuItemSync.keyEquivalent = "U"
        menuItemSync.enabled = true
        
        // We set the menuItemQuit
        menuItemQuit.title = "Quit"
        menuItemQuit.action = Selector("terminate:")
        menuItemQuit.enabled = true
    }
    
    func updateMenuItems(items: [String]){
        
        statusBarMenu.removeAllItems()
        
        if(items.count > 0){
            
            for(var i=0;i<items.count; i++){
                
                let menuItem  : NSMenuItem = NSMenuItem()
                var title = items[i]
                
                if(title.characters.count > 40){
                    title = title.substringWithRange(Range(start: title.startIndex, end: title.startIndex.advancedBy(36)))
                    title = title + "..."
                }
                
                menuItem.title      = String(i+1)+". "+title
                menuItem.action     = Selector("copyItemToClipboard:")
                menuItem.tag        = i
                menuItem.target     = self
                menuItem.enabled    = true
                
                
                statusBarMenu.addItem(menuItem)
                
            }
            
            statusBarMenu.addItem(NSMenuItem.separatorItem())
        }
        
        //Add items to status bar menu
        
        statusBarMenu.addItem(menuItemSend)
        statusBarMenu.addItem(menuItemSync)
        statusBarMenu.addItem(NSMenuItem.separatorItem())
        statusBarMenu.addItem(menuItemQuit)
        
    }
    
    func copyItemToClipboard(sender: AnyObject?) {
        
        
        
    }
    
    func sendDataToClipboard(sender : AnyObject?) {
        
        
        
    }
    
    func updateMetaClipboard(sender : AnyObject?) {
        
        
    }
    
}