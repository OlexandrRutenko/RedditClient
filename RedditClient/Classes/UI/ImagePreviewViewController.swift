//
//  ImagePreviewViewController.swift
//  RedditClient
//
//  Created by Olexandr Rutenko on 4/22/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var imageUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let imageUrl = imageUrl else {
            activityIndicatorView.stopAnimating()
            return
        }
        ImageService.shared.load(from: imageUrl, success: { [weak self] image in
                self?.activityIndicatorView.stopAnimating()
                self?.imageView.image = image
            }, error: { [weak self] errorString in
                self?.activityIndicatorView.stopAnimating()
                debugPrint(errorString)
        })
    }

    @IBAction func saveImage(_ sender: Any) {
        if let image = imageView.image {
            // callback for success save
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}
