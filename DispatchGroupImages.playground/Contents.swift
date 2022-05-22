import PlaygroundSupport
import UIKit
import Foundation

PlaygroundPage.current.needsIndefiniteExecution = true

// MARK: - Download Images with URLSession

func downloadImagesWithURLSession() {
    let group = DispatchGroup()

    let base = "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-"
    let ids = [ 466881, 466910, 466925, 466931, 466978, 467028, 467032, 467042, 467052 ]

    var images: [UIImage] = []

    for id in ids {
        guard let url = URL(string: "\(base)\(id)-jpeg.jpg") else {
            print("error: invalid url: \(base)\(id)-jpeg.jpg")
            continue
        }
        
        group.enter()
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { group.leave() }
            guard error == nil else { return { print("error: \(error?.localizedDescription ?? "unknown")") }() }
            guard let httpResponse = (response as? HTTPURLResponse), 200...299 ~= httpResponse.statusCode else {
                return { print("error: not 2xx status code in response. got \((response as? HTTPURLResponse)?.statusCode ?? -1)") }()
            }
            guard let data = data else { return { print("error: invalid image data") }() }
            guard let image = UIImage(data: data) else { return { print("error: cannot convert data to image") }() }
            images.append(image)
        }.resume()
    }

    group.notify(queue: .main) {
        images[0]
        images[8]
    }
}

//downloadImagesWithURLSession()

// MARK: - Download Images with Queue

func downloadImagesWithQueue() {
    let group = DispatchGroup()
    let queue = DispatchQueue.global(qos: .utility)
    
    let base = "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-"
    let ids = [ 466881, 466910, 466925, 466931, 466978, 467028, 467032, 467042, 467052 ]

    var images: [UIImage] = []

    for id in ids {
        guard let url = URL(string: "\(base)\(id)-jpeg.jpg") else {
            print("error: invalid url: \(base)\(id)-jpeg.jpg")
            continue
        }
        
        queue.async(group: group) {
            guard let data = try? Data(contentsOf: url) else { return { print("error: invalid image data") }() }
            guard let image = UIImage(data: data) else { return { print("error: cannot convert data to image") }() }
            images.append(image)
        }
    }
    
    group.notify(queue: .main) {
        images[0]
        images[8]
    }
}

downloadImagesWithQueue()
