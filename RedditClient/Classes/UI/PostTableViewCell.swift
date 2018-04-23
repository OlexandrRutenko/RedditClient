//
//  PostTableViewCell.swift
//  RedditClient
//
//  Created by Olexandr Rutenko on 4/21/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import UIKit

protocol PostTableViewCellDelegate: class {
    func previewImage(on cell: PostTableViewCell)
}

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    weak var delegate: PostTableViewCellDelegate?
    private let kImageViewHeightConstant: CGFloat = 200
    
    override func awakeFromNib() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(previewImage))
        thumbnailImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    override func prepareForReuse() {
        titleLabel.text = nil
        thumbnailImageView.image = nil
        authorLabel.text = nil
        commentsLabel.text = nil
        dateLabel.text = nil
    }

    func setUpWithModel(model: PostViewModel) {
        titleLabel.text = model.title
        if let imageURL = model.thumbnail {
            imageViewHeightConstraint.constant = kImageViewHeightConstant
            ImageService.shared.load(from: imageURL, success: { [weak self] image in
                self?.thumbnailImageView.image = image
                }, error: { errorString in
                    debugPrint(errorString)
                })
        } else {
            imageViewHeightConstraint.constant = 0.0
        }
        authorLabel.text = model.author
        commentsLabel.text = model.commentsCount
        dateLabel.text = model.creationDate
    }
    // MARK: - Actions
    @objc private func previewImage() {
        delegate?.previewImage(on: self)
    }
}
