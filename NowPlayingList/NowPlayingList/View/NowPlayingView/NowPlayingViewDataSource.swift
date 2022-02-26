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

class NowPlayingViewDataSource: NSObject, DecodeRequestable {
    typealias ChangedListCompletion = () -> Void
    typealias SelectedItmeCompletion = (Movie) -> Void
    
    private var changedListCompletion: ChangedListCompletion?
    private var selectedItmeCompletion: SelectedItmeCompletion?
    
    private var lastPage: Int = 1
    private var totalPage: Int = 0
    private var movies: [Movie] = [] {
        didSet { changedListCompletion?() }
    }
    
    init(changedListCompletion: @escaping ChangedListCompletion,
         selectedItmeCompletion: @escaping SelectedItmeCompletion) {
        self.changedListCompletion = changedListCompletion
        self.selectedItmeCompletion = selectedItmeCompletion
    }
}

extension NowPlayingViewDataSource: NowPlayingViewModel {
    func loadNowPlayingList() {
        guard let url = NowPlayingListAPI.nowplaying(lastPage).makeURL() else {
            NSLog("\(#function) - URL 생성 실패")
            return
        }
        loadNowPlayingList(url: url, type: Page.self) { page in
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
        
        let movie = movies[indexPath.item]
        cell.configureData(title: movie.title, rated: movie.rated)
        guard let posterPath = movie.posterPath else {
            return cell
        }
        let nsPath = NSString(string: posterPath)
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: nsPath) {
            cell.configureImage(cachedImage)
        } else {
            DispatchQueue.global().async {
                guard let imageURL = NowPlayingListAPI.makeImageURL(posterPath) else {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let seletedMovie = movies[indexPath.item]
        selectedItmeCompletion?(seletedMovie)
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
