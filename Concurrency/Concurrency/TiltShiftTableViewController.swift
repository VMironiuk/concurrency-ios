//
//  TiltShiftTableViewController.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 02.06.2022.
//

import UIKit

class TiltShiftTableViewController: UITableViewController {
    private static let imagesCount = 10
    private let operationQueue = OperationQueue()
    private var cachedImages: [UIImage?] = Array(repeating: nil, count: imagesCount)
    // 2
//    private let queue = DispatchQueue(label: "com.volodymyroniuk")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 1
//        operationQueue.maxConcurrentOperationCount = 1
        // 2
//        operationQueue.underlyingQueue = queue
        // 3
//        operationQueue.underlyingQueue = DispatchQueue.global(qos: .utility)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Self.imagesCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.photoImageView.image = nil
        cell.isLoading = true
        
        if cachedImages.count > indexPath.row, let cachedImage = cachedImages[indexPath.row] {
            cell.photoImageView.image = cachedImage
            cell.isLoading = false
        } else {
            let name = "\(indexPath.row).png"
            let inputImage = UIImage(named: name)!

            print("Tilt shifting image \(name)")
            
            let operation = TiltShiftOperation(inputImage: inputImage)
            operation.completionBlock = { [weak self] in
                DispatchQueue.main.async {
                    guard let cell = tableView.cellForRow(at: indexPath) as? PhotoCell else { return }
                    cell.photoImageView.image = operation.outputImage
                    cell.isLoading = false
                    if let count = self?.cachedImages.count, count > indexPath.row {
                        self?.cachedImages[indexPath.row] = operation.outputImage
                    }
                }
            }
            operationQueue.addOperation(operation)
        }
        
        return cell
    }
}
