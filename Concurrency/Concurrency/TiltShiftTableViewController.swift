//
//  TiltShiftTableViewController.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 09.06.2022.
//

import UIKit

class TiltShiftTableViewController: UITableViewController {
    
    private let operationQueue = OperationQueue()
    
    private var urls: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImageUrls()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        urls.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.display(image: nil)
        cell.isLoading = true
        
        let url = urls[indexPath.row]
        let networkImageOperation = NetworkImageOperation(url: url)
        networkImageOperation.completionBlock = { [weak self] in
            DispatchQueue.main.async {
                let cell = self?.tableView.cellForRow(at: indexPath) as? PhotoCell
                cell?.display(image: networkImageOperation.image)
                cell?.isLoading = false
            }
        }
        
        operationQueue.addOperation(networkImageOperation)

        return cell
    }
    
    private func fetchImageUrls() {
        let url = Bundle.main.url(forResource: "Photos", withExtension: "plist")!
        let data = try! Data(contentsOf: url)
        let urlStrings = try! PropertyListSerialization.propertyList(from: data, format: nil) as! [String]
        urls = urlStrings.compactMap { URL(string: $0) }
    }
}
