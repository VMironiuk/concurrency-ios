//
//  NetworkImageOperation.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 14.06.2022.
//

import UIKit

typealias ImageOperationCompletion = ((Data?, URLResponse?, Error?) -> Void)?

final class NetworkImageOperation: AsyncOperation {
    private let url: URL
    private let completion: ImageOperationCompletion
    private(set) var image: UIImage?
    
    init(url: URL, completion: ImageOperationCompletion = nil) {
        self.url = url
        self.completion = completion
        super.init()
    }
    
    convenience init?(string: String, completion: ImageOperationCompletion = nil) {
        guard let url = URL(string: string) else { return nil }
        self.init(url: url, completion: completion)
    }
    
    override func main() {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            defer { self.state = .finished }
            
            if let completion = self.completion {
                completion(data, response, error)
                return
            }
            
            guard error == nil, let data = data else { return }
            
            self.image = UIImage(data: data)
        }.resume()
    }
}
