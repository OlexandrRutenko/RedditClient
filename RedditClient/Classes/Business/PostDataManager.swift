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
    func saveState()
}

struct UserDefaultsKeys {
    static let postsKey = "posts"
    static let afterKey = "after"
}

final class PostDataManager: NSObject, PostDataProtocol {
    private let service = PostService()
    private var after: String?
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
    override init() {
        super.init()
        if let data = UserDefaults.standard.value(forKey: UserDefaultsKeys.postsKey) as? Data,
            let oldPosts = try? PropertyListDecoder().decode(Array<PostViewModel>.self, from: data) {
            posts = oldPosts
            after = UserDefaults.standard.object(forKey: UserDefaultsKeys.afterKey) as? String
        } else {
            loadPosts()
        }
    }
    var onDidLoadPosts: (() -> ())?
    var onDidUpdateLoading: ((_ loading: Bool) -> ())?
    func resetData() {
        after = nil
        posts.removeAll()
    }
    func loadPosts() {
        if loading == true {
            return
        }
        loading = true
        service.getPosts(after: after, success: { [weak self] page in
            self?.loading = false
            self?.after = page.after
            guard let currentPosts = page.posts else {
                return
            }
            let postViewModels = currentPosts.map({ PostViewModel($0) })
            self?.posts += postViewModels
        }, error: { [weak self] errorString in
            self?.loading = false
            debugPrint(errorString)
        })
    }
    var numberOfCells: Int {
        return posts.count
    }
    func postCellViewModel(at indexPath: IndexPath) -> PostViewModel {
        return posts[indexPath.row]
    }
    // restoration
    func saveState() {
        UserDefaults.standard.set(after, forKey: UserDefaultsKeys.afterKey)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(posts), forKey: UserDefaultsKeys.postsKey)
    }
}

