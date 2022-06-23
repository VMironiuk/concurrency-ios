//
//  TiltShiftTableViewController.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 16.06.2022.
//

import UIKit

class TiltShiftTableViewController: UITableViewController {
    
    private let queue = OperationQueue()
    private var urls: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchURLs()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        urls.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PhotoCell.self)) as! PhotoCell
        cell.isLoading = true
        cell.display(nil)
        
        let networkOperation = NetworkImageOperation(url: urls[indexPath.row])
        
        let tiltShiftOperation = TiltShiftOperation()
        tiltShiftOperation.addDependency(networkOperation)
        tiltShiftOperation.onImageProcessed = { image in
            let cell = tableView.cellForRow(at: indexPath) as? PhotoCell
            cell?.display(tiltShiftOperation.outputImage)
            cell?.isLoading = false
        }
        
        queue.addOperation(networkOperation)
        queue.addOperation(tiltShiftOperation)
        
        return cell
    }
    
    private func fetchURLs() {
        let url = Bundle.main.url(forResource: "Photos", withExtension: "plist")!
        let data = try! Data(contentsOf: url)
        let urlStrings = try! PropertyListSerialization.propertyList(from: data, format: nil) as! [String]
        urls = urlStrings.compactMap { URL(string: $0) }
    }
}
