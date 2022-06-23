//
//  TiltShiftOperation.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 21.06.2022.
//

import UIKit

final class TiltShiftOperation: Operation {
    
    private let ciContext = CIContext()
    private var inputImage: UIImage?
    private(set) var outputImage: UIImage?
    /// Callback which will be run *on the main thread*
    /// when the operation completes.
    var onImageProcessed: ((UIImage?) -> Void)?
    
    init(inputImage: UIImage? = nil) {
        self.inputImage = inputImage
        super.init()
    }
    
    override func main() {
        let dependencyImage = dependencies
            .compactMap { ($0 as? ImageProvider)?.image }
            .first
        
        guard let inputImage = inputImage ?? dependencyImage else {
            return
        }

        let rect = CGRect(x: 0, y: 0, width: inputImage.size.width, height: inputImage.size.height)
        let filter = TiltShiftFilter(image: inputImage)!
        let cgImage = ciContext.createCGImage(filter.outputImage!, from: rect)!
        outputImage = UIImage(cgImage: cgImage)
        
        if let onImageProcessed = onImageProcessed {
            DispatchQueue.main.async { [weak self] in
                onImageProcessed(self?.outputImage)
            }
        }
    }
}

extension TiltShiftOperation: ImageProvider {
    var image: UIImage? { outputImage }
}
