//
//  ViewController.swift
//  CoreImageFilters
//
//  Created by Gunnar Herzog on 11/01/15.
//  Copyright (c) 2015 Gunnar Herzog. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var originalImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        originalImage = imageView.image
    }

    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
        startProcessing()
        dispatch_async(GlobalUserInitiatedQueue) {
            var ciImage = CIImage(image: self.originalImage)
            let filter = CIFilter(name: "CISepiaTone", withInputParameters: [
                kCIInputImageKey: ciImage])
            let sepiaOutput = filter.outputImage
            
            let blur = CIFilter(name: "CIGaussianBlur", withInputParameters: [
                kCIInputImageKey: sepiaOutput,
                kCIInputRadiusKey: 4.0])
            
            let output = blur.outputImage
            let context = CIContext(options: [:])
            let cgImage = context.createCGImage(output, fromRect: output.extent())
            let outputImage = UIImage(CGImage: cgImage)
            
            dispatch_async(GlobalMainQueue) {
                self.imageView.image = outputImage
                self.endProcessing()
            }
        }
    }

    func startProcessing() {
        activityIndicator.startAnimating()
        imageView.alpha = 0.2
    }
    
    func endProcessing() {
        activityIndicator.stopAnimating()
        imageView.alpha = 1
    }
}

