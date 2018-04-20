//
//  PostService.swift
//  RedditClient
//
//  Created by Olexandr Rutenko on 4/13/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation

class PostService {
    let baseUrl = URL(string: "https://www.reddit.com")!
    private let networkManager: NetworkManager
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    convenience init() {
        self.init(networkManager: NetworkManager())
    }
    func getPosts() {
        let resource = Resource(endpoint: baseUrl, path: "top.json", params: ["limit": 50])
        networkManager.sendRequest(withResource: resource, success: { (data) in
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
            debugPrint(jsonObject)
        }, error: { (errorString) in
            debugPrint(errorString)
        })
    }
}
