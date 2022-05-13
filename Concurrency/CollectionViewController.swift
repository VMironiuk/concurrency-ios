//
//  CollectionViewController.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 11.05.2022.
//

import UIKit

private let reuseIdentifier = PhotoCell.reuseIdentifier

class CollectionViewController: UICollectionViewController {
    
    // MARK: - Private Properties
    
    private let cellSpacing: CGFloat = 1
    private let columnCount: CGFloat = 3
    private let edgeSpace: CGFloat = 2
    private var cellSize: CGFloat?
    private lazy var photoURLs: [URL] = {
        fetchPhotoURLs()
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private Methods
    
    private func fetchPhotoURLs() -> [URL] {
        guard let photosURL = Bundle.main.url(forResource: "Photos", withExtension: "plist") else {
            fatalError("Error: Failed to fetch URL to Photos.plist from the main bundle")
        }
        guard let photosData = try? Data(contentsOf: photosURL) else {
            fatalError("Error: Failed to fetch data by URL \(photosURL.absoluteString)")
        }
        guard let photosURLStrings = try? PropertyListSerialization
            .propertyList(from: photosData, format: nil) as? [String] else {
            fatalError("Error: Failed to parse Photos.plist")
        }
        return photosURLStrings.compactMap { URL(string: $0) }
    }
    
    private func downloadImageWithGlobalQueue(at indexPath: IndexPath) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else {
                return
            }
            let url = self.photoURLs[indexPath.item]
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                if let cell = self.collectionView.cellForItem(at: indexPath) as? PhotoCell {
                    cell.imageView.image = image
                }
            }
        }
    }
    
    private func downloadImageWithURLSession(at indexPath: IndexPath) {
        let url = photoURLs[indexPath.item]
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                if let cell = self.collectionView.cellForItem(at: indexPath) as? PhotoCell {
                    cell.imageView.image = image
                }
            }
        }.resume()
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoURLs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        cell.imageView.image = nil
        downloadImageWithURLSession(at: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if cellSize == nil {
            let emptySpace = edgeSpace + (cellSpacing * columnCount - 1)
            cellSize = (view.frame.size.width - emptySpace) / columnCount
        }
        return CGSize(width: cellSize!, height: cellSize!)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        cellSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        cellSpacing
    }
}
