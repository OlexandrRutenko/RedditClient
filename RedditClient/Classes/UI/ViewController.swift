//
//  ViewController.swift
//  RedditClient
//
//  Created by Olexandr Rutenko on 4/12/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    //we can use dependecy injection for PostDataProtocol
    private let postDataManager = PostDataManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        postDataManager.loadPosts()
        postDataManager.onDidLoadPosts = { [weak self] in
            self?.tableView.reloadData()
        }
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDataManager.numberOfCells
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier)!
        if let postCell = cell as? PostTableViewCell {
            postCell.setUpWithModel(model: postDataManager.postCellViewModel(at: indexPath))
        }
        return cell
    }
}
