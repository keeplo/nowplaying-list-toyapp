//
//  NowPlayingListCell.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/17.
//

import UIKit
import Then
import SnapKit

struct NowPlayingListCellModel {
    let title: String
    let rated: Double
    let imagePath: String?
}

final class NowPlayingListCell: UICollectionViewCell {
    private var posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    private var movieTitleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .label
    }
    private var movieRatedLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.textColor = .green
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        let cellStackView = UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.addArrangedSubview(self.posterImageView)
            $0.addArrangedSubview(self.movieTitleLabel)
            $0.addArrangedSubview(self.movieRatedLabel)
        }
        self.contentView.addSubview(cellStackView)
        cellStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        posterImageView.image = nil
        movieTitleLabel.text = Strings.emptyString
        movieRatedLabel.text = Strings.emptyString
    }
}

extension NowPlayingListCell: Configurable {
    func configureData<T>(_ data: T) {
        guard let model = data as? NowPlayingListCellModel else { return }
        
        movieTitleLabel.text = model.title
        movieRatedLabel.text = Strings.starText + "\(model.rated)"
        // 이미지 추가
//        guard let posterPath = movie.posterPath else { return cell }
//        let nsPath = NSString(string: posterPath)
//        if let cachedImage = ImageCacheManager.shared.object(forKey: nsPath) {
//            cell.configureImage(cachedImage)
//        } else {
//            guard let imageURL = NowPlayingListAPI.makeImageURL(posterPath) else {
//                NSLog("\(#function) - 포스터 URL 생성 실패")
//                return cell
//            }
//            ImageCacheManager.loadImage(url: imageURL, path: nsPath) { image in
//                if indexPath == collectionView.indexPath(for: cell) {
//                    cell.configureImage(image)
//                }
//            }
//        }
    }
}
