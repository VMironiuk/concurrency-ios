//
//  TiltShiftTableViewController.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 02.06.2022.
//

import UIKit

class TiltShiftTableViewController: UITableViewController {
    private let operationQueue = OperationQueue()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.photoImageView.image = nil
        cell.isLoading = true
        
        let name = "\(indexPath.row).png"
        let inputImage = UIImage(named: name)!

        print("Tilt shifting image \(name)")
        
        let operation = TiltShiftOperation(inputImage: inputImage)
        operation.completionBlock = {
            DispatchQueue.main.async {
                guard let cell = tableView.cellForRow(at: indexPath) as? PhotoCell else { return }
                cell.photoImageView.image = operation.outputImage
                cell.isLoading = false
            }
        }
        operationQueue.addOperation(operation)
        return cell
    }
}
