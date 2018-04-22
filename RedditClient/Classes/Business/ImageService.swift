//
//  ImageService.swift
//  RedditClient
//
//  Created by Olexandr Rutenko on 4/21/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import UIKit

class ImageService {
    static let shared = ImageService()
    let imageCacheArray = NSCache<NSString, UIImage>()
    
    func load(from url: URL, success: @escaping (UIImage) -> Void, error errorCallback: @escaping (String) -> Void) {
        let urlString = url.absoluteString as NSString
        if let cachedImage = imageCacheArray.object(forKey: urlString) {
            DispatchQueue.main.async {
                success(cachedImage)
            }
        } else {
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                            errorCallback(error.localizedDescription)
                    } else if let data = data {
                        if let response = response, response.isValidResponse() {
                            if let image = UIImage(data: data) {
                                self?.imageCacheArray.setObject(image, forKey: urlString)
                                success(image)
                            } else {
                                errorCallback("Invalid data")
                            }
                        } else {
                            errorCallback("Incorrect response")
                        }
                    } else {
                        errorCallback("No data")
                    }
                }
            }.resume()
        }
    }
}

