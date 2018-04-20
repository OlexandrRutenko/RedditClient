//
//  NetworkManager.swift
//  RedditClient
//
//  Created by Olexandr Rutenko on 4/12/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation

typealias RequestSuccessBlock = ((Data) -> Void)
typealias RequestErrorBlock = ((String) -> Void)

class NetworkManager {
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        return URLSession(configuration: configuration)
    }()
    
    func sendRequest(withResource resource: Resource, success: @escaping RequestSuccessBlock, error errorCallback: @escaping RequestErrorBlock) {
        guard let urlRequest = resource.buildRequest() else {
            return
        }
        session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                errorCallback(error.localizedDescription)
            } else if let data = data {
                if let httpResponse = response as? HTTPURLResponse,
                    200...299 ~= httpResponse.statusCode {
                    success(data)
                } else {
                    errorCallback("Incorrect response")
                }
            } else {
                errorCallback("No data")
            }
        }.resume()
    }
}
