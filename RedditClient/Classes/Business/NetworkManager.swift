//
//  NetworkManager.swift
//  RedditClient
//
//  Created by Olexandr Rutenko on 4/12/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation

protocol Network {
    func sendRequest<T: Decodable>(withResource resource: Resource, success: @escaping (T) -> Void, error errorCallback: @escaping (String) -> Void)
}

class NetworkManager: Network {
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        return URLSession(configuration: configuration)
    }()
    
    func sendRequest<T: Decodable>(withResource resource: Resource, success: @escaping (T) -> Void, error errorCallback: @escaping (String) -> Void) {
        guard let urlRequest = resource.buildRequest() else {
            return
        }
        session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                errorCallback(error.localizedDescription)
            } else if let data = data {
                if let response = response, response.isValidResponse() {
                    let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
                    debugPrint(jsonObject)
                    do {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        success(result)
                    } catch {
                        errorCallback("Invalid format")
                    }
                } else {
                    errorCallback("Incorrect response")
                }
            } else {
                errorCallback("No data")
            }
        }.resume()
    }
}
