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
    private let network: Network
    init(network: Network) {
        self.network = network
    }
    convenience init() {
        self.init(network: NetworkManager())
    }
    func getPosts(success: @escaping (Page) -> Void, error errorCallback: @escaping (String) -> Void) {
        let resource = Resource(endpoint: baseUrl, path: "top.json", params: ["limit": 50])
        network.sendRequest(withResource: resource, success: { (data) in
            DispatchQueue.main.async {
                success(data)
            }
        }, error: { (errorString) in
            errorCallback(errorString)
        })
    }
}
