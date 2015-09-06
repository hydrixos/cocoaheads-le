//
//  SignalProducerDemo.swift
//  RACSamples
//
//  Created by Torsten Lehmann on 02.09.15.
//  Copyright (c) 2015 Torsten Lehmann. All rights reserved.
//

import Foundation
import ReactiveCocoa

// [A First Look at ReactiveCocoa 3.0](http://blog.scottlogic.com/2015/04/24/first-look-reactive-cocoa-3.html)
// [ReactiveCocoa 3.0 - Signal Producers and API clarity](http://blog.scottlogic.com/2015/04/28/reactive-cocoa-3-continued.html)
func demoSignalProducer() {
    
    func createSignalProducer() -> SignalProducer<String, NoError> {
        var count = 0
        return SignalProducer {
            sink, disposable in
        
            println("Creating the timer signal producer")

            let timer = NSTimer.schedule(repeatInterval: 0.1) { timer in
                println("Emitting a next event")
                println("diposed: \(disposable.disposed)")
                sendNext(sink, "tick #\(count++)")
            }
            
            
            disposable.addDisposable({ () -> () in
                timer.invalidate()
            })
            
        }
    }
    
//    let signalProducer = createSignalProducer()
//
//    let d = signalProducer   start(next: { println($0) })
//    
//    signalProducer |> startWithSignal({ (<#Signal<T, E>#>, <#Disposable#>) -> () in
//        <#code#>
//    })
//    
//    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC))
//    dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
//        println("Tschu")
//        d.dispose()
//    }
}