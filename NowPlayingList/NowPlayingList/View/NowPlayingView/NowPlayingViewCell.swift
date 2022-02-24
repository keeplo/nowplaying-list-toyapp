//
//  NowPlayingViewCell.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/17.
//

import UIKit

final class NowPlayingViewCell: UICollectionViewCell {
    var movieThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }()
    var movieRatedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .green
        return label
    }()
    let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCellLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpCellLayout()
    }
    
    func setUpCellLayout() {
        cellStackView.addArrangedSubview(movieThumbnailImageView)
        cellStackView.addArrangedSubview(movieTitleLabel)
        cellStackView.addArrangedSubview(movieRatedLabel)
        contentView.addSubview(cellStackView)
            
        cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    func configureData(title: String, rated: Double) {
        movieTitleLabel.text = title
        movieRatedLabel.text = "★" + "\(rated)"
    }
    
    func configureImage(_ image: UIImage) {
        movieThumbnailImageView.image = image
    }
}
