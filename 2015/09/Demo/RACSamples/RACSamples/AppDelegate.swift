//
//  AppDelegate.swift
//  RACSamples
//
//  Created by Torsten Lehmann on 02.09.15.
//  Copyright (c) 2015 Torsten Lehmann. All rights reserved.
//

import Cocoa
import ReactiveCocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        demoSignal()
        demoSignalProducer()
    }
}

