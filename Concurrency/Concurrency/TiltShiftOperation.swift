//
//  TiltShiftOperation.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 03.06.2022.
//

import UIKit

final class TiltShiftOperation: Operation {
    private static let context = CIContext()
    private let inputImage: UIImage
    private(set) var outputImage: UIImage?
    
    init(inputImage: UIImage) {
        self.inputImage = inputImage
        super.init()
    }
    
    override func main() {
        guard let filter = TiltShiftFilter(image: inputImage, radius: 3),
              let output = filter.outputImage else {
            print("Failed to generate tilt shift image")
            return
        }

        print("Generating UIImage")
        let fromRect = CGRect(origin: .zero, size: inputImage.size)
        guard let cgImage = Self.context.createCGImage(output, from: fromRect) else {
            print("No image generated")
            return
        }
        
        outputImage = UIImage(cgImage: cgImage)
    }
}
