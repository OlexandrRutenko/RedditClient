//
//  Post.swift
//  RedditClient
//
//  Created by Olexandr Rutenko on 4/20/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation

struct Post: Decodable {
    let title: String?
    let author: String?
    let thumbnail: URL?
    let imageURL: URL?
    let creationDate: Double?
    let commentsCount: Int?
    enum DataKey: String, CodingKey {
        case data
    }
    enum PreviewKey: String, CodingKey {
        case images
    }
    enum ImagesKey: String, CodingKey {
        case source
    }
    enum SourceKey: String, CodingKey {
        case url
    }
    enum CodingKeys: String, CodingKey {
        case data
        case title
        case author
        case thumbnail
        case preview
        case creationDate = "created_utc"
        case commentsCount = "num_comments"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DataKey.self)
        let data = try container.nestedContainer(keyedBy: CodingKeys.self,
                                                 forKey: .data)
        title = try data.decodeIfPresent(String.self,
                                         forKey: .title)
        author = try data.decodeIfPresent(String.self,
                                          forKey: .author)
        creationDate = try data.decodeIfPresent(Double.self,
                                                  forKey: .creationDate)
        thumbnail = try data.decodeIfPresent(URL.self,
                                             forKey: .thumbnail)
        commentsCount = try data.decodeIfPresent(Int.self,
                                                 forKey: .commentsCount)
        
        let preview = try? data.nestedContainer(keyedBy: PreviewKey.self, forKey: .preview)
        guard let previewContainer = preview else {
            imageURL = nil
            return
        }
        var imagesUnkeyedContainer = try previewContainer.nestedUnkeyedContainer(forKey: .images)
        let imageContainer = try imagesUnkeyedContainer.nestedContainer(keyedBy: ImagesKey.self)
        let source = try imageContainer.nestedContainer(keyedBy: SourceKey.self, forKey: .source)
        imageURL = try source.decodeIfPresent(URL.self, forKey: .url)
    }
}
