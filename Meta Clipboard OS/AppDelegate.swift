//
//  AppDelegate.swift
//  Meta Clipboard OS
//
//  Created by Guillermo A Araiza Torres on 26/01/16.
//  Copyright © 2016 Disforma. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        window = NSApplication.sharedApplication().windows.first!
        window!.makeKeyAndOrderFront(self)
        window?.orderOut(self)
        window!.close()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

