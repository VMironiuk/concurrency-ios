//
//  PhotoCell.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 02.06.2022.
//

import UIKit

class PhotoCell: UITableViewCell {
    @IBOutlet private(set) weak var photoImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var isLoading: Bool {
        get { activityIndicator.isAnimating }
        set {
            if newValue {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
}
