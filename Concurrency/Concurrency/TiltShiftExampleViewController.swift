//
//  TiltShiftExampleViewController.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 27.06.2022.
//

import UIKit

class TiltShiftExampleViewController: UIViewController {
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var tiltShiftingLabel: UILabel!
    @IBOutlet private weak var filteredImageView: UIImageView!
    
    private let ciContext = CIContext()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let image = UIImage(named: "dark_road_small")!
        let filter = TiltShiftFilter(image: image)!
        let ciImage = filter.outputImage!
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let cgImage = ciContext.createCGImage(ciImage, from: rect)!
        filteredImageView.image = UIImage(cgImage: cgImage)
        tiltShiftingLabel.isHidden = true
        activityIndicator.stopAnimating()
    }
}
