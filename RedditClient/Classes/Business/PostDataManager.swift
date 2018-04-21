//
//  PostDataManager.swift
//  RedditClient
//
//  Created by Olexandr Rutenko on 4/21/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation

protocol PostDataProtocol {
    func loadPosts()
    func postCellViewModel(at indexPath: IndexPath) -> PostViewModel
    var onDidLoadPosts: (() -> ())? { get set }
    var numberOfCells: Int { get }
}

final class PostDataManager: PostDataProtocol {
    private let service = PostService()
    private var posts = [PostViewModel]() {
        didSet {
            onDidLoadPosts?()
        }
    }
    var onDidLoadPosts: (() -> ())?
    func loadPosts() {
        service.getPosts(success: { [weak self] page in
            guard let currentPosts = page.posts else {
                return
            }
            let postViewModels = currentPosts.map({ PostViewModel($0) })
            self?.posts += postViewModels
        }, error: { erroString in
            debugPrint(erroString)
        })
    }
    var numberOfCells: Int {
        return posts.count
    }
    func postCellViewModel(at indexPath: IndexPath) -> PostViewModel {
        return posts[indexPath.row]
    }
}

