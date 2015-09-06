//
//  ViewController.swift
//  RACSamples
//
//  Created by Torsten Lehmann on 02.09.15.
//  Copyright (c) 2015 Torsten Lehmann. All rights reserved.
//

import Cocoa
import ReactiveCocoa

class ViewController: NSViewController {

    @IBOutlet weak var button: NSButton!
    var cocoaAction: CocoaAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let pressedAction: Action<String, Void, NoError> = Action { _ in
            println("Clicked via RAC")
            return SignalProducer<Void, NoError>.empty
        }
        cocoaAction = CocoaAction(pressedAction, input: "")
        button.target = cocoaAction
        button.action = CocoaAction.selector
    }

    @IBAction func buttonClicked(sender: AnyObject) {
        println("Button clicked via target action")
    }
}

