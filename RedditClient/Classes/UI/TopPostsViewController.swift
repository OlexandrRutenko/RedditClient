//
//  TopPostsViewController.swift
//  RedditClient
//
//  Created by Olexandr Rutenko on 4/12/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import UIKit

class TopPostsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    //we can use dependecy injection for PostDataProtocol
    private let postDataManager = PostDataManager()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        postDataManager.loadPosts()
        postDataManager.onDidLoadPosts = { [weak self] in
            self?.tableView.reloadData()
        }
        postDataManager.onDidUpdateLoading = { [weak self] loading in
            if loading == false {
                self?.refreshControl.endRefreshing()
            }
        }
        setUpTableView()
    }
    private func setUpTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.refreshControl = refreshControl
        tableView.estimatedRowHeight = 250
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        postDataManager.resetData()
        postDataManager.loadPosts()
    }
}

extension TopPostsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDataManager.numberOfCells
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        if let postCell = cell as? PostTableViewCell {
            postCell.delegate = self
            postCell.setUpWithModel(model: postDataManager.postCellViewModel(at: indexPath))
        }
        return cell
    }
}

extension TopPostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //if 10 posts left load new page
        if indexPath.item == postDataManager.numberOfCells - 10 {
            postDataManager.loadPosts()
        }
    }
}

extension TopPostsViewController: PostTableViewCellDelegate {
    func previewImage(on cell: PostTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        if let indexPath = indexPath {
            let currentPost = postDataManager.postCellViewModel(at: indexPath)
            let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
            if let imagePreviewVC = storyboard.instantiateViewController(withIdentifier: "ImagePreviewViewController") as? ImagePreviewViewController {
                imagePreviewVC.imageUrl = currentPost.imageURL
                navigationController?.pushViewController(imagePreviewVC, animated: true)
            }
        }
    }
}
