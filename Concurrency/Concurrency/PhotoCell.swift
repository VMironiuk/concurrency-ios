//
//  PhotoCell.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 18.06.2022.
//

import UIKit

class PhotoCell: UITableViewCell {

    @IBOutlet private weak var photoImageView: UIImageView!
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
        photoImageView.image = image
    }
}
