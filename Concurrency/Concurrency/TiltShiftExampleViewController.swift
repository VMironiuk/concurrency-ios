//
//  TiltShiftExampleViewController.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 09.06.2022.
//

import UIKit

class TiltShiftExampleViewController: UIViewController {
    
    @IBOutlet private weak var filteredImageView: UIImageView!
    @IBOutlet private weak var tiltShiftingLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private let ciContext = CIContext()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let image = UIImage(named: "dark_road_small")!
        let tiltShiftFilter = TiltShiftFilter(image: image)
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        if let outputImage = tiltShiftFilter?.outputImage,
           let cgImage = ciContext.createCGImage(outputImage, from: imageRect) {
            filteredImageView.image = UIImage(cgImage: cgImage)
            tiltShiftingLabel.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
}
