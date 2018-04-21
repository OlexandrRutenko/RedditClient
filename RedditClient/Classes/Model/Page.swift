//
//  Page.swift
//  RedditClient
//
//  Created by Olexandr Rutenko on 4/20/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation

struct Page: Decodable {
    let before: String?
    let after: String?
    let posts: [Post]?
    enum DataKey: String, CodingKey {
        case data
    }
    enum CodingKeys: String, CodingKey {
        case before
        case after
        case children
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DataKey.self)
        let data = try container.nestedContainer(keyedBy: CodingKeys.self,
                                                 forKey: .data)
        before = try data.decodeIfPresent(String.self,
                                          forKey: .before)
        after = try data.decodeIfPresent(String.self,
                                         forKey: .after)
        posts = try data.decodeIfPresent([Post].self,
                                         forKey: .children)
    }
}
