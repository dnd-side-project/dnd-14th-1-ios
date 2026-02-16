//
//  TokenStatView.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/16/26.
//

import UIKit

import SnapKit
import Then

class TokenStatView: UIVisualEffectView {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let amountLabel = UILabel()
    
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 209, height: 92)
    }
    
    init(image: UIImage, title: String, value: String) {
        let blurEffect = UIBlurEffect(style: .light)
        super.init(effect: blurEffect)
        imageView.image = image
        titleLabel.text = title
        amountLabel.text = value
        addSubView()
        setStyle()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        layer.cornerRadius = 28
        clipsToBounds = true
        contentView.backgroundColor = .white.withAlphaComponent(0.1)
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        
        titleLabel.do {
            $0.font = .title3_b
        }
        
        amountLabel.do {
            $0.font = .hakgyoansimDunggeunmisoBold_24
        }
    }
    
    private func setLayout() {
        imageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(20)
            $0.size.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.top)
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
        }
        
        amountLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.trailing.equalTo(titleLabel.snp.trailing)
        }
    }
    
    private func addSubView() {
        contentView.addSubviews(
            imageView,
            titleLabel,
            amountLabel
        )
    }
}
