//
//  AppDelegate.swift
//  DontTRYhfs
//
//  Created by Torsten Lehmann on 03.10.16.
//  Copyright © 2016 Torsten Lehmann. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var userWantsErrorMessagesButton: NSButton!
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        styleTextView(textView: textView)
        textView.string = "C'mon choose a file. I'm waiting …"
    }
    

    @IBAction func chooseFileButtonPressed(_ sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = true
        openPanel.beginSheetModal(for: window) { [weak self] buttonIndex in
        
            guard let s = self else { return }
            
            // if user cancels we interpret the result as no selection
            let urls = buttonIndex == NSFileHandlingPanelCancelButton ? [] : openPanel.urls
            if s.userWantsErrorMessagesButton.state == 0 {
                s.loadFileContentsNaive(fileURLs: urls)
            } else {
                s.loadFileContentsWithProperErrorHandling(fileURLs: urls)
            }
        }
    }
    
    
    
    //////////////////////////
    // converting optionals //
    //////////////////////////
    
    
    private func loadFileContentsNaive(fileURLs: [URL]) {
        let textViewContent: String
        // we convert the error thrown by `String.init(contentsOf:)` to an optional with `try?`
        if let url = fileURLs.first, let content = try? String(contentsOf: url) {
            textViewContent = content
        } else {
            textViewContent = "Oh no, maybe HFS has lost your file? But I'm not sure!"
        }
        self.textView.string = textViewContent
    }
    
    
    
    //////////////
    // throwing //
    //////////////
    
    
    private func loadFileContentsWithProperErrorHandling(fileURLs: [URL]) {
        let textViewContent: String
        do {
            textViewContent = try loadFileContents(fileURLs: fileURLs)
        } catch ContentLoadingError.fileIsADirectory(let filePath) {
            textViewContent = "File at path \"\(filePath)\" is a directory."
        } catch ContentLoadingError.noFileSelected {
            textViewContent = "There was no file selected. Sorry."
        } catch {
            textViewContent = "Wohohoo. That was unexpected! But we could not know this because the type system does not help us here."
        }
        self.textView.string = textViewContent
    }
    
    
    
    
    // define a type that conforms to the `Error` protocol
    enum ContentLoadingError: Error {
        case noFileSelected
        case fileIsADirectory(filePath: String)
    }
    
    // `throws` propagates error to the calling scope
    private func loadFileContents(fileURLs: [URL]) throws -> String {
        guard let _ = fileURLs.first else { throw ContentLoadingError.noFileSelected }
        // we have to use try before throwing `loadFileContent` and before `map` because it rethrows
        return try fileURLs.map { try loadFileContent(fileURL: $0) }.reduce("", +)
    }
    
    private func loadFileContent(fileURL: URL) throws -> String {

        func isDirectoryError(error: NSError) -> Bool {
            // in reality this is the file permission error message
            return error.domain == NSCocoaErrorDomain && error.code == 257
        }
        
        do {
            return try String(contentsOf: fileURL)
        } catch let error as NSError where isDirectoryError(error: error) {
            throw ContentLoadingError.fileIsADirectory(filePath: fileURL.path)
        }
    }

}

