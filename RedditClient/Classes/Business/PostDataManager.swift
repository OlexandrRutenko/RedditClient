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
    func resetData()
    func postCellViewModel(at indexPath: IndexPath) -> PostViewModel
    var onDidLoadPosts: (() -> ())? { get set }
    var onDidUpdateLoading: ((_ loading: Bool) -> ())? { get set }
    var numberOfCells: Int { get }
}

final class PostDataManager: PostDataProtocol {
    private let service = PostService()
    private var currentPage: Page?
    private var loading: Bool = false {
        didSet {
            onDidUpdateLoading?(loading)
        }
    }
    private var posts = [PostViewModel]() {
        didSet {
            onDidLoadPosts?()
        }
    }
    var onDidLoadPosts: (() -> ())?
    var onDidUpdateLoading: ((_ loading: Bool) -> ())?
    func resetData() {
        currentPage = nil
        posts.removeAll()
    }
    func loadPosts() {
        if loading == true {
            return
        }
        loading = true
        service.getPosts(after: currentPage?.after, success: { [weak self] page in
            self?.loading = false
            self?.currentPage = page
            guard let currentPosts = page.posts else {
                return
            }
            let postViewModels = currentPosts.map({ PostViewModel($0) })
            self?.posts += postViewModels
        }, error: { [weak self] erroString in
            self?.loading = false
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

