//
//  PhotoCell.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 27.06.2022.
//

import UIKit

class PhotoCell: UITableViewCell {

    @IBOutlet private weak var photoImage: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var isLoading: Bool = true {
        didSet {
            if isLoading {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    func display(_ image: UIImage?) {
        photoImage.image = image
    }
}
