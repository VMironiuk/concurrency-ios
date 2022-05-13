//
//  PhotoCell.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 12.05.2022.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    static let reuseIdentifier = "PhotoCell"
    @IBOutlet private(set) weak var imageView: UIImageView!
}
