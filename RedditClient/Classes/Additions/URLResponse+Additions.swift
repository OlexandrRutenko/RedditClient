//
//  URLResponse+Additions.swift
//  RedditClient
//
//  Created by Olexandr Rutenko on 4/21/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation

extension URLResponse {
    func isValidResponse() -> Bool {
        if let httpResponse = self as? HTTPURLResponse,
            200...299 ~= httpResponse.statusCode {
            return true
        } else {
            return false
        }
    }
}
