//
//  SignalDemo.swift
//  RACSamples
//
//  Created by Torsten Lehmann on 02.09.15.
//  Copyright (c) 2015 Torsten Lehmann. All rights reserved.
//

import Foundation
import ReactiveCocoa

struct TimerDisposable: Disposable {
    
    let timer: NSTimer
    
    var disposed: Bool {
        return !timer.valid
    }
    
    func dispose() {
        println("dispose")
        timer.invalidate()
    }
}

func createSignal() -> Signal<String, NoError> {
    var count = 0
    return Signal {
        sink in
        println("Creating the timer signal")
        let timer = NSTimer.schedule(repeatInterval: 1.0) { _ in
            println("Emitting a next event")
            sendNext(sink, "tick #\(count++)")
            if count == 10 {
                sendCompleted(sink)
            }
        }
        return TimerDisposable(timer: timer)
    }
}

// [A First Look at ReactiveCocoa 3.0](http://blog.scottlogic.com/2015/04/24/first-look-reactive-cocoa-3.html)
// [ReactiveCocoa 3.0 - Signal Producers and API clarity](http://blog.scottlogic.com/2015/04/28/reactive-cocoa-3-continued.html)
func demoSignal() {
    
//    let signal = createSignal()

//    signal.observe(next: { println($0) })

//    signal.observe(SinkOf {
//        event in
//        switch event {
//        case let .Next(data):
//            println(data.value)
//        default:
//            break
//        }
//        })

//    let upperMapping: Signal<String, NoError> -> Signal<String, NoError> = map({ $0.uppercaseString })
//    let newSignal = upperMapping(signal)
//    newSignal.observe(next: { println($0) })
//
//    signal
//        |> upperMapping
//        |> observe(next: { println($0) })
//
//    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC))
//    dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
//        println("Tschu")
//    }
}