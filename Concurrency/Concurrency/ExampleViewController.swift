//
//  ExampleViewController.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 02.06.2022.
//

import UIKit

class ExampleViewController: UIViewController {
    @IBOutlet private weak var titledImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defer {
            activityIndicator.stopAnimating()
        }
        
        let image = UIImage(named: "dark_road_small")!
        
        guard let filter = TiltShiftFilter(image: image, radius:3),
              let output = filter.outputImage else {
            return { titleLabel.text = "Failed to generate tilt shift image" }()
        }
        
        let context = CIContext()
        
        guard let cgImage = context.createCGImage(output, from: CGRect(origin: .zero, size: image.size)) else {
            return { titleLabel.text = "No image generated" }()
        }
        
        titledImageView.image = UIImage(cgImage: cgImage)
        
        titleLabel.isHidden = true
    }
}
