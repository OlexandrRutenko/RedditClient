//
//  String+Additions.swift
//  RedditClient
//
//  Created by Olexandr Rutenko on 4/12/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation

extension String {
    static func urlParamsStringEncoded(_ params: ParamsType) -> String? {
        if params.keys.count == 0 {
            return nil
        }
        var paramsArray: [String] = []
        for (key, value) in params {
            paramsArray.append(key + "=" + String(describing: value))
        }
        let paramsString = paramsArray.joined(separator: "&")
        debugPrint(paramsString)
        return paramsString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
