//
//  ViewController.swift
//  CoreImageFilters
//
//  Created by Gunnar Herzog on 11/01/15.
//  Copyright (c) 2015 Gunnar Herzog. All rights reserved.
//

import UIKit

typealias Filter = CIImage ->  CIImage

infix operator • { associativity left }

func •(filter1: Filter, filter2: Filter) -> Filter {
    return { image in
        filter2(filter1(image))
    }
}

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

func bump(center: CIVector) -> Filter {
    return { image in
        let filter = CIFilter(name: "CIBumpDistortion", withInputParameters:[kCIInputImageKey: image, kCIInputCenterKey: center])
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
            
            let filter = sepia() • blur(4.0) • bump(CIVector(x: self.originalImage.size.width / 2, y: self.originalImage.size.height / 2))
            let output = filter(ciImage)
            
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

