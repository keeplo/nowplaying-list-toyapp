//
//  NowPlayingViewDataSource.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/17.
//

import Foundation
import UIKit

protocol NowPlayingViewModel {
    func loadNowPlayingList()
}

class NowPlayingViewDataSource: NSObject {
    typealias ChangedListCompletion = () -> Void
    
    private var changedListCompletion: ChangedListCompletion?
    
    private let networkManager: NowPlayingListNetworkManager
    private var movies: [Movie] = [] {
        didSet {
            changedListCompletion?()
        }
    }
    
    init(networkManager: NowPlayingListNetworkManager, changedListCompletion: @escaping ChangedListCompletion) {
        self.networkManager = networkManager
        self.changedListCompletion = changedListCompletion
    }
}

extension NowPlayingViewDataSource: NowPlayingViewModel {
    func loadNowPlayingList() {
        guard let url = NowPlayingListAPI.nowplaying.makeURL() else {
            NSLog("\(#function) - URL 생성 실패")
            return
        }
        print(#function)
        networkManager.loadNowPlayingList(url: url) { pageResults in
            self.movies.append(contentsOf: pageResults)
        }
    }
}

extension NowPlayingViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingViewCell.className, for: indexPath) as? NowPlayingViewCell else {
            return UICollectionViewCell()
        }
        
        let movie = movies[indexPath.row]
        let nsPath = NSString(string: movie.posterPath)
        cell.configureData(title: movie.title, rated: movie.rated)
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: nsPath) {
            cell.configureImage(cachedImage)
        } else {
            DispatchQueue.global().async {
                guard let imageURL = NowPlayingListAPI.makeImageURL(movie.posterPath) else {
                    NSLog("\(#function) - 포스터 URL 생성 실패")
                    return
                }
                if let imageData = NSData(contentsOf: imageURL),
                    let image = UIImage(data: Data(imageData)) {
                    ImageCacheManager.shared.setObject(image, forKey: nsPath)
                    DispatchQueue.main.async {
                        cell.configureImage(image)
                    }
                }
            }
        }
        
        return cell
    }
}
