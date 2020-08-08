//
//  AppDelegate.swift
//  keyword-search
//
//  Created by Eddie Cameron on 6/08/20.
//  Copyright © 2020 Eddie Cameron. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
        
    @IBAction func openSupportSite(_ sender: Any) {
        let url = URL(string: "https://github.com/EddieCameron/keyword-searches-in-safari")!
        if NSWorkspace.shared.open(url) {
            print("Help page opened" )
        }
    }
}
