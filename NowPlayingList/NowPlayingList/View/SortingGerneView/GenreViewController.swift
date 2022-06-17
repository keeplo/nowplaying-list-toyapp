//
//  GenreViewController.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/25.
//

import UIKit
import Then
import SnapKit

final class GenreViewController: UIViewController {
    
    private let dummyGuideLabel = UILabel(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        self.setupAttributes()
    }
    
    private func setupLayout() {
        self.view.addSubview(self.dummyGuideLabel)
        self.dummyGuideLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.view.do {
            $0.backgroundColor = .systemBackground
        }
        
        self.dummyGuideLabel.do {
            $0.text = self.className
            $0.textColor = .label
        }
    }
    
}
