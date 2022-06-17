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
    private let viewModel: GenreViewModel
    
    init(viewModel: GenreViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        self.dummyGuideLabel.do {
            $0.text = self.className
            $0.textColor = .label
        }
    }
    
}
