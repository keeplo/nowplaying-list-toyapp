//
//  SearchedListViewCell.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/25.
//

import UIKit

final class SearchedListViewCell: UITableViewCell {
    var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }()
    var movieDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .label
        return label
    }()
    var movieRatedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .label
        return label
    }()
    let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCellLayout()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCellLayout()
    }
    
    override func prepareForReuse() {
        posterImageView.image = nil
        movieTitleLabel.text = ""
        movieRatedLabel.text = ""
    }
}

// MARK: -- Custom Methods
extension SearchedListViewCell {
    private func setUpCellLayout() {
        contentView.addSubview(posterImageView)
    
        let height = UIScreen.main.bounds.height / 5 - (CGFloat.padding * 4)
        let width = height * 2 / 3 - (CGFloat.padding * 4)
        posterImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        posterImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor,
                                             constant: CGFloat.padding * 2).isActive = true
        posterImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor,
                                               constant: CGFloat.padding * 4).isActive = true
        
        labelsStackView.addArrangedSubview(movieTitleLabel)
        labelsStackView.addArrangedSubview(movieDateLabel)
        labelsStackView.addArrangedSubview(movieRatedLabel)
        contentView.addSubview(labelsStackView)
            
        labelsStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor,
                                           constant: CGFloat.padding * 2).isActive = true
        labelsStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor,
                                               constant: CGFloat.padding * 4).isActive = true
        labelsStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor,
                                                constant: CGFloat.padding * 2).isActive = true
    }
    
    func configureData(title: String, date: String?, rated: Double) {
        movieTitleLabel.text = title
        movieDateLabel.text = date
        movieRatedLabel.text = "★" + "\(rated)"
    }
    
    func configureImage(_ image: UIImage) {
        posterImageView.image = image
    }
}
