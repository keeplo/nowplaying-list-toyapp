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
    func refreshCollectionView()
}

class NowPlayingViewDataSource: NSObject {
    typealias ChangedListCompletion = () -> Void
    
    private var changedListCompletion: ChangedListCompletion?
    
    private let networkManager: NowPlayingListNetworkManager
    private var lastPage: Int = 1 {
        didSet {
            print("changed lasgPage \(lastPage)")
        }
    }
    private var totalPage: Int = 0 {
        didSet {
            print("changed totalPage \(totalPage)")
        }
    }
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
        guard let url = NowPlayingListAPI.nowplaying(lastPage).makeURL() else {
            NSLog("\(#function) - URL 생성 실패")
            return
        }
        print(#function)
        networkManager.loadNowPlayingList(url: url) { page in
            self.movies.append(contentsOf: page.results)
            self.lastPage = page.page
            self.totalPage = page.totalPages
        }
    }
}

extension NowPlayingViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
                        if indexPath == collectionView.indexPath(for: cell) {
                            cell.configureImage(image)
                        }
                    }
                }
            }
        }
        
        return cell
    }
}

extension NowPlayingViewDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if lastPage < totalPage, indexPath.item == (movies.count / 4) {
            lastPage += 1
            loadNowPlayingList()
        }
    }
}

extension NowPlayingViewDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let itemPerRow: CGFloat = 2
        let itemRate:CGFloat = 2/3
        let padding: CGFloat = 20
        
        let cellWidth = (width - padding * 2) / itemPerRow
        let cellHeight = (cellWidth / itemRate) + padding + padding
                
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
