//
//  NavigationView.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/03/17.
//

import UIKit
import Then
import SnapKit

final class NavigationView: UIView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
    
    private func setupLayout() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.do {
            $0.backgroundColor = .systemGroupedBackground
        }
        
        self.titleLabel.do {
            $0.textColor = .label
            $0.font = .systemFont(ofSize: 30, weight: .bold)
        }
    }
    
    private let titleLabel = UILabel(frame: .zero)
}
