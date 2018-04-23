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
    
    var imageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let imageURL = imageURL else {
            activityIndicatorView.stopAnimating()
            return
        }
        loadImage(imageURL)
    }
    private func loadImage(_ imageUrl: URL) {
        activityIndicatorView.startAnimating()
        ImageService.shared.load(from: imageUrl, success: { [weak self] image in
            self?.activityIndicatorView.stopAnimating()
            self?.imageView.image = image
            }, error: { [weak self] errorString in
                self?.activityIndicatorView.stopAnimating()
                debugPrint(errorString)
        })
    }
    // MARK: - Actions
    @IBAction func saveImage(_ sender: Any) {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlertController(text: error.localizedDescription)
        } else {
            showAlertController(text: "Saved")
        }
    }
    func showAlertController(text: String) {
        let alertController = UIAlertController(title: text,
                                                message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

extension ImagePreviewViewController {
    override func encodeRestorableState(with coder: NSCoder) {
        guard let imageURL = imageURL else { return }
        coder.encode(imageURL, forKey: "imageURL")
        super.encodeRestorableState(with: coder)
    }
    override func decodeRestorableState(with coder: NSCoder) {
        imageURL = coder.decodeObject(forKey: "imageURL") as? URL
        super.decodeRestorableState(with: coder)
    }
    override func applicationFinishedRestoringState() {
        guard let imageUrl = imageURL else { return }
        loadImage(imageUrl)
    }
}
