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
}

