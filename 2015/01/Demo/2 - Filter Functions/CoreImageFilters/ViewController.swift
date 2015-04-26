//
//  ViewController.swift
//  CoreImageFilters
//
//  Created by Gunnar Herzog on 11/01/15.
//  Copyright (c) 2015 Gunnar Herzog. All rights reserved.
//

import UIKit

typealias Filter = CIImage ->  CIImage

func sepia() -> Filter {
    return { image in
        let filter = CIFilter(name: "CISepiaTone", withInputParameters: [kCIInputImageKey: image])
        return filter.outputImage
    }
}

func blur(radius: Double) -> Filter {
    return { image in
        let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: [kCIInputImageKey: image, kCIInputRadiusKey: radius])
        return filter.outputImage
    }
}

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
            
            let output = blur(4.0)(sepia()(ciImage))
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

