//
//  NetworkImageOperation.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 20.06.2022.
//

import UIKit

typealias NetworkImageCompletion = ((Data?, URLResponse?, Error?) -> Void)?

final class NetworkImageOperation: AsyncOperation {
    private let url: URL
    private let completion: NetworkImageCompletion
    private(set) var image: UIImage?
    
    init(url: URL, completion: NetworkImageCompletion = nil) {
        self.url = url
        self.completion = completion
        super.init()
    }
    
    convenience init?(string: String, completion: NetworkImageCompletion = nil) {
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

extension NetworkImageOperation: ImageProvider {}
