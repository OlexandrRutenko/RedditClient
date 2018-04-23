//
//  PostViewModel.swift
//  RedditClient
//
//  Created by Olexandr Rutenko on 4/21/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import UIKit

struct PostViewModel: Codable {
    let title: String?
    let author: String?
    let thumbnail: URL?
    let imageURL: URL?
    let commentsCount: String?
    let creationDate: String?
}

extension PostViewModel {
    init(_ post: Post) {
        title = post.title
        author = post.author
        if let url = post.thumbnail, UIApplication.shared.canOpenURL(url) {
            thumbnail = url
        } else {
            thumbnail = nil
        }
        imageURL = post.imageURL
        commentsCount = "\(post.commentsCount ?? 0) comments"
        if let timeInterval = post.creationDate {
           creationDate = Date().timeLeft(from: Date(timeIntervalSince1970: timeInterval))
        } else {
            creationDate = nil
        }
    }
}
