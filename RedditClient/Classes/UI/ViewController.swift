//
//  ViewController.swift
//  RedditClient
//
//  Created by Olexandr Rutenko on 4/12/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let postService = PostService()
    override func viewDidLoad() {
        super.viewDidLoad()
        postService.getPosts()
    }
    
}

