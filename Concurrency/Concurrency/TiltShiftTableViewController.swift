//
//  TiltShiftTableViewController.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 27.06.2022.
//

import UIKit

class TiltShiftTableViewController: UITableViewController {
    
    private var urls: [URL] = []
    private var operations: [IndexPath : [Operation]] = [:]
    private let queue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchURLs()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        urls.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        cell.display(nil)
        cell.isLoading = true
        
        let url = urls[indexPath.row]
        let networkImageOperation = NetworkImageOperation(url: url)
        
        let tiltShiftOperation = TiltShiftOperation()
        tiltShiftOperation.addDependency(networkImageOperation)
        tiltShiftOperation.onImageProcessed = { [weak self] image in
            let cell = self?.tableView.cellForRow(at: indexPath) as? PhotoCell
            cell?.display(image)
            cell?.isLoading = false
        }
                
        queue.addOperation(networkImageOperation)
        queue.addOperation(tiltShiftOperation)
        
        if let operations = operations[indexPath] {
            operations.forEach { $0.cancel() }
        }
        
        operations[indexPath] = [networkImageOperation, tiltShiftOperation]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let operations = operations[indexPath] {
            operations.forEach { $0.cancel() }
        }
    }
    
    private func fetchURLs() {
        let url = Bundle.main.url(forResource: "Photos", withExtension: "plist")!
        let data = try! Data(contentsOf: url)
        let urlStrings = try! PropertyListSerialization.propertyList(from: data, format: nil) as! [String]
        urls = urlStrings.compactMap { URL(string: $0) }
    }
}
