//
//  TiltShiftOperation.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 28.06.2022.
//

import UIKit

final class TiltShiftOperation: AsyncOperation {
    
    private var inputImage: UIImage?
    private(set) var outputImage: UIImage?
    private let ciContext = CIContext()
    /// This completion performs on the main thread
    var onImageProcessed: ((UIImage?) -> Void)?
    
    init(image: UIImage? = nil) {
        self.inputImage = image
        super.init()
    }
    
    override func main() {
        defer { state = .finished }
        
        if let imageDependency = dependencies.compactMap({ $0 as? ImageDataProvider }).first?.image {
            inputImage = imageDependency
        }
        
        guard let inputImage = inputImage else {
            return
        }

        guard !isCancelled else { return }
        
        let filter = TiltShiftFilter(image: inputImage)
        let rect = CGRect(x: 0, y: 0, width: inputImage.size.width, height: inputImage.size.height)
        
        guard !isCancelled else { return }
        
        let cgImage = ciContext.createCGImage(filter!.outputImage!, from: rect)!
        outputImage = UIImage(cgImage: cgImage)
        
        if let onImageProcessed = onImageProcessed {
            DispatchQueue.main.async { [weak self] in
                onImageProcessed(self?.outputImage)
            }
        }
    }
}

extension TiltShiftOperation: ImageDataProvider {
    var image: UIImage? {
        outputImage
    }
}
