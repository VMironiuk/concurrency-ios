//
//  NetworkImageOperation.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 28.06.2022.
//

import UIKit

typealias NetworkImageCompletion = ((Data?, URLResponse?, Error?) -> Void)?

final class NetworkImageOperation: AsyncOperation {
    
    private let url: URL
    /// This completion performs on the main thread
    private let completion: NetworkImageCompletion
    private var outputImage: UIImage?
    private var dataTask: URLSessionDataTask?
    
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
        dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            defer { self.state = .finished }
            
            guard !self.isCancelled else { return }
            
            if let completion = self.completion {
                DispatchQueue.main.async {
                    completion(data, response, error)
                }
                return
            }
            
            guard let data = data, error == nil else { return }
            
            self.outputImage = UIImage(data: data)
        }
        
        dataTask?.resume()
    }
    
    override func cancel() {
        super.cancel()
        dataTask?.cancel()
    }
}

extension NetworkImageOperation: ImageDataProvider {
    var image: UIImage? {
        outputImage
    }
}
