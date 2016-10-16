//
//  Styling.swift
//  DontTRYhfs
//
//  Created by Torsten Lehmann on 03.10.16.
//  Copyright © 2016 Torsten Lehmann. All rights reserved.
//

import Cocoa

func styleTextView(textView: NSTextView) {
    
    textView.font = NSFont(name: "Menlo", size: 14)
    textView.backgroundColor = NSColor(red:0.176, green:0.176, blue:0.176, alpha:1)
    textView.textColor = NSColor(red:0.8, green:0.8, blue:0.8, alpha:1)
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.2
    textView.defaultParagraphStyle = paragraphStyle
    
    textView.textContainerInset = NSSize(width: 16, height: 20)
}
