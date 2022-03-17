//
//  SearchedListCell.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/25.
//

import UIKit
import Then
import SnapKit
import Kingfisher

struct SearchedListCellModel {
    let title: String
    let date: String
    let rated: Double
    let imagePath: String?
}

final class SearchedListCell: UITableViewCell {
    private var posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    private var movieTitleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .label
    }
    private var movieDateLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.textColor = .label
    }
    private var movieRatedLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.textColor = .label
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.posterImageView)
    
        let height = UIScreen.main.bounds.height / 5 - (CGFloat.padding * 4)
        let width = height * 2 / 3 - (CGFloat.padding * 4)
        self.posterImageView.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(height)
            make.top.equalToSuperview().offset(CGFloat.padding * 2)
            make.leading.equalToSuperview().offset(CGFloat.padding * 4)
        }
        
        let labelsStackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 8
            $0.distribution = .fillProportionally
            $0.addArrangedSubview(self.movieTitleLabel)
            $0.addArrangedSubview(self.movieDateLabel)
            $0.addArrangedSubview(self.movieRatedLabel)
        }
        self.contentView.addSubview(labelsStackView)
        labelsStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.padding * 2)
            make.leading.equalTo(self.posterImageView.snp.trailing).offset(CGFloat.padding * 4)
            make.trailing.equalToSuperview().offset(-CGFloat.padding * 2)
        }
    }
    
    override func prepareForReuse() {
        posterImageView.kf.cancelDownloadTask()
        movieTitleLabel.text = Strings.emptyString
        movieRatedLabel.text = Strings.emptyString
    }
}

extension SearchedListCell: Configurable {
    func configureData<T>(_ data: T) {
        guard let model = data as? SearchedListCellModel else { return }
        
        movieTitleLabel.text = model.title
        movieDateLabel.text = model.date
        movieRatedLabel.text = Strings.starText + "\(model.rated)"
        if let path = model.imagePath,
            let url = NowPlayingListAPI.makeImageURL(path) {
            posterImageView.kf.setImage(with: url)
        }
    }
}
