//
//  TiltShiftExampleViewController.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 16.06.2022.
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
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let tiltShiftFilter = TiltShiftFilter(image: image)
        guard let ciImage = tiltShiftFilter?.outputImage,
              let cgImage = ciContext.createCGImage(ciImage, from: rect) else { fatalError() }
        
        filteredImageView.image = UIImage(cgImage: cgImage)
        tiltShiftingLabel.isHidden = true
        activityIndicator.stopAnimating()
    }
}
