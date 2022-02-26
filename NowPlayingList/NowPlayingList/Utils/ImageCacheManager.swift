//
//  ImageCacheManager.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/24.
//

import Foundation.NSCache
import UIKit.UIImage

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
    
    static func loadImage(url: URL, path key: NSString, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global().async {
            if let imageData = NSData(contentsOf: url),
                let image = UIImage(data: Data(imageData)) {
                ImageCacheManager.shared.setObject(image, forKey: key)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
}

