//
//  ViewController.swift
//  Meta Clipboard OS
//
//  Created by Guillermo A Araiza Torres on 26/01/16.
//  Copyright © 2016 Disforma. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var window: NSWindow!
    let pasteBoard              = NSPasteboard.generalPasteboard()
    
    // If there aren't custom hotkeys, use Cmd+shift+G
    var flags: NSEventModifierFlags = NSEventModifierFlags(rawValue: 1179914)   // Cmd+Shift
    var keyCodeG: UInt16 = UInt16(1)                                            //  Letter S
    var keyCodeS: UInt16 = UInt16(32)                                            // Letter U
    
    var statusBar       = NSStatusBar.systemStatusBar()
    var statusBarItem   = NSStatusItem()
    var statusBarMenu   = NSMenu()
    
    var menuItemSync  : NSMenuItem = NSMenuItem()
    var menuItemSend : NSMenuItem = NSMenuItem()
    var menuItemQuit : NSMenuItem = NSMenuItem()
    
    var keyValueStoreDidChangeObserver: AnyObject?
    
    var metaClipboard: MetaClipboard = MetaClipboard()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metaClipboard.update()
        
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
        
        updateStatusBarItems()
        
        
        
        // GlobalMonitor for ShortCtus.
        let options = NSDictionary(object: kCFBooleanTrue, forKey: kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString) as CFDictionaryRef
        let trusted = AXIsProcessTrustedWithOptions(options)
        if (trusted) {
            NSEvent.addGlobalMonitorForEventsMatchingMask(NSEventMask.KeyDownMask, handler: self.keyHandler)
        }
        
        
        // Create The Observer.
        keyValueStoreDidChangeObserver = NSNotificationCenter.defaultCenter().addObserverForName(NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification) -> Void in
            
            self.updateMetaClipboard(self)
            
        })
        
    }
    
    func keyHandler(event: NSEvent!) {
        
        let modifierFlags = event.modifierFlags
        
        //print("Pressed \(modifierFlags)")
        //print("Pressed \(event.keyCode)")
        
        if (modifierFlags == flags) {
            if event.keyCode == keyCodeG {
                sendDataToClipboard(self)
            }
        }
        
        if (modifierFlags == flags) {
            if event.keyCode == keyCodeS {
                updateMetaClipboard(self)
            }
        }
        
    }
    
    func copyItemToClipboard(sender: AnyObject?) {
        
        let index       = sender!.tag()
        let theString = metaClipboard.find(index)
        
        copyToClipboard(theString)
        updateStatusBarItems()
        
    }
    
    func sendDataToClipboard(sender : AnyObject?) {
        
        // Only if is a string this method will append the clipboard to the metaclipboard.
        if  let clipboardString = pasteBoard.stringForType(NSPasteboardTypeString) {
            
            metaClipboard.append(clipboardString)
            updateStatusBarItems()
        }
        
    }
    
    func updateMetaClipboard(sender : AnyObject?) {
        

        metaClipboard.update()
        
        if let clipboardString = metaClipboard.first() as String? {
            copyToClipboard(clipboardString)
        }
        
        updateStatusBarItems()
        
    }
    
    func copyToClipboard(theString: String){
        
        pasteBoard.clearContents()
        if pasteBoard.writeObjects([theString]) {
            print("Clipboard Updated")
        }
    }
    
    
    
    func updateStatusBarItems(){
    
        
        statusBarMenu.removeAllItems()
        let items = metaClipboard.metaClipboardItems
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
        
        //Add default items to status bar menu
        statusBarMenu.addItem(menuItemSend)
        statusBarMenu.addItem(menuItemSync)
        statusBarMenu.addItem(NSMenuItem.separatorItem())
        statusBarMenu.addItem(menuItemQuit)
        
    }
    
    
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }

}

