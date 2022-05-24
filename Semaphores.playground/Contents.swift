import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

func semaphoreDemo() {
    let queue = DispatchQueue.global(qos: .userInitiated)
    let semaphore = DispatchSemaphore(value: 2)
    for i in 1...10 {
        semaphore.wait()
        queue.async {
            defer { semaphore.signal() }
            print("Start job # \(i)")
            Thread.sleep(until: Date().addingTimeInterval(2))
            print("Finish job # \(i)")
        }
    }
}

//semaphoreDemo()

func downloadWithURLSession() {
    let group = DispatchGroup()
    let semaphore = DispatchSemaphore(value: 2)
    let base = "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-"
    let ids = [ 466881, 466910, 466925, 466931, 466978, 467028, 467032, 467042, 467052 ]

    var images: [UIImage] = []
    
    for id in ids {
        semaphore.wait()
        group.enter()
        let url = URL(string: "\(base)\(id)-jpeg.jpg")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            defer {
                group.leave()
                semaphore.signal()
            }
            let image = UIImage(data: data!)!
            images.append(image)
        }.resume()
    }
    
    group.notify(queue: .main) {
        images[0]
        images[8]
    }
}

//downloadWithURLSession()

func downloadWithQueue() {
    let queue = DispatchQueue.global(qos: .userInitiated)
    let group = DispatchGroup()
    let semaphore = DispatchSemaphore(value: 1)
    let base = "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-"
    let ids = [ 466881, 466910, 466925, 466931, 466978, 467028, 467032, 467042, 467052 ]
    
    var images: [UIImage] = []
    
    for id in ids {
        let url = URL(string: "\(base)\(id)-jpeg.jpg")!
        semaphore.wait()
        queue.async(group: group) {
            defer { semaphore.signal() }
            let data = try! Data(contentsOf: url)
            let image = UIImage(data: data)!
            images.append(image)
        }
    }
    
    group.notify(queue: .main) {
        images[0]
        images[8]
    }
}

downloadWithQueue()
