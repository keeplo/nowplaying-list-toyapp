//
//  NowPlayingViewModel.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/17.
//

import Foundation
import UIKit

protocol NowPlayingViewModel {
    func fetchNowPlayingList()
}

final class NowPlayingViewModelImpl: NSObject, DecodeRequestable {
    typealias ChangedListCompletion = () -> Void
    typealias SelectedItmeCompletion = (Movie) -> Void
    
    private var changedListCompletion: ChangedListCompletion?
    private var selectedItmeCompletion: SelectedItmeCompletion?
    
    private var page: (last: Int, total: Int) = (1, 0)
    private var movies: [Movie] = [] {
        didSet { changedListCompletion?() }
    }
    
    init(changedListCompletion: @escaping ChangedListCompletion,
         selectedItmeCompletion: @escaping SelectedItmeCompletion) {
        self.changedListCompletion = changedListCompletion
        self.selectedItmeCompletion = selectedItmeCompletion
    }
}

extension NowPlayingViewModelImpl: NowPlayingViewModel{
    func fetchNowPlayingList() {
        guard let url = NowPlayingListAPI.nowplaying(page.last).makeURL() else {
            NSLog("\(#function) - URL 생성 실패")
            return
        }
        parseRequestedData(url: url, type: Page.self) { page in
            self.movies.append(contentsOf: page.results)
            self.page = (page.page, page.totalPages)
        }
    }
}

// MARK: -- CollectionView DataSource
extension NowPlayingViewModelImpl: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingViewCell.className, for: indexPath) as? NowPlayingViewCell else {
            return UICollectionViewCell()
        }
        
        let movie = movies[indexPath.item]
        cell.configureData(movie)
        
        guard let posterPath = movie.posterPath else { return cell }
        let nsPath = NSString(string: posterPath)
        if let cachedImage = ImageCacheManager.shared.object(forKey: nsPath) {
            cell.configureImage(cachedImage)
        } else {
            guard let imageURL = NowPlayingListAPI.makeImageURL(posterPath) else {
                NSLog("\(#function) - 포스터 URL 생성 실패")
                return cell
            }
            ImageCacheManager.loadImage(url: imageURL, path: nsPath) { image in
                if indexPath == collectionView.indexPath(for: cell) {
                    cell.configureImage(image)
                }
            }
        }
        
        return cell
    }
}

// MARK: -- CollectionView Delegate
extension NowPlayingViewModelImpl: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if page.last < page.total, indexPath.item == (movies.count / 4) {
            page.last += 1
            fetchNowPlayingList()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let seletedMovie = movies[indexPath.item]
        selectedItmeCompletion?(seletedMovie)
    }
}

// MARK: -- CollectionView DelegateFlowLayout
extension NowPlayingViewModelImpl: UICollectionViewDelegateFlowLayout {
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
