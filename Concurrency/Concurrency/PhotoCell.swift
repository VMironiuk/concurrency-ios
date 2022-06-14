//
//  PhotoCell.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 09.06.2022.
//

import UIKit

class PhotoCell: UITableViewCell {
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var photoImageView: UIImageView!
    
    var isLoading: Bool = true {
        didSet {
            if isLoading {
                activityIndicator.startAnimating()
            }
            else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    func display(image: UIImage?) {
        photoImageView.image = image
    }
}
