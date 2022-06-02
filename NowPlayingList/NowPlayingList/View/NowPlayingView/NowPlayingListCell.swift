//
//  NowPlayingListCell.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/17.
//

import UIKit
import Then
import SnapKit
import Kingfisher

struct NowPlayingListCellModel {
    let title: String
    let rated: Double
    let imagePath: String?
}

final class NowPlayingListCell: UICollectionViewCell {
    private var posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    private var titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .label
    }
    private var ratedLabel = UILabel().then {
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
        let width = UIScreen.main.bounds.width
        let itemPerRow: CGFloat = 2
        let itemRate:CGFloat = 2/3
        let padding: CGFloat = 20
        
        let cellWidth = (width - padding * 2) / itemPerRow
        let cellHeight = (cellWidth / itemRate) + (padding * 2)

        let imageHeight = cellHeight - self.titleLabel.font.lineHeight - self.ratedLabel.font.lineHeight
        
        self.contentView.addSubview(self.posterImageView)
        self.posterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(cellWidth)
            make.height.equalTo(imageHeight)
        }
        
        let cellStackView = UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.addArrangedSubview(self.titleLabel)
            $0.addArrangedSubview(self.ratedLabel)
        }
        
        self.contentView.addSubview(cellStackView)
        cellStackView.snp.makeConstraints { make in
            make.top.equalTo(self.posterImageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        posterImageView.kf.cancelDownloadTask()
        titleLabel.text = Strings.emptyString
        ratedLabel.text = Strings.emptyString
    }
}

extension NowPlayingListCell: Configurable {
    func configureData<T>(_ data: T) {
        guard let model = data as? NowPlayingListCellModel else { return }
        
        titleLabel.text = model.title
        ratedLabel.text = Strings.starText + "\(model.rated)"
        if let path = model.imagePath,
            let url = NowPlayingListAPI.makeImageURL(path) {
            posterImageView.kf.setImage(with: url)
        }
    }
}
