//
//  NowPlayingViewCell.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/17.
//

import UIKit

final class NowPlayingViewCell: UICollectionViewCell {
    private var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }()
    private var movieRatedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .green
        return label
    }()
    private let cellStackView: UIStackView = {
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
    
    override func prepareForReuse() {
        posterImageView.image = nil
        movieTitleLabel.text = ""
        movieRatedLabel.text = ""
    }
}

// MARK: -- Custom Methods
extension NowPlayingViewCell {
    private func setUpCellLayout() {
        cellStackView.addArrangedSubview(posterImageView)
        cellStackView.addArrangedSubview(movieTitleLabel)
        cellStackView.addArrangedSubview(movieRatedLabel)
        contentView.addSubview(cellStackView)
            
        cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
}

extension NowPlayingViewCell: Configurable {
    func configureData<T>(_ data: T) {
        guard let movie = data as? Movie else { return }
        
        movieTitleLabel.text = movie.title
        movieRatedLabel.text = "★" + "\(movie.rated)"
    }
    
    func configureImage(_ image: UIImage) {
        posterImageView.image = image
    }
}
