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
    
    var title: String {
        get { titleLabel.text ?? "" }
        set { titleLabel.text = newValue }
    }
    
    var icon: UIImage {
        get { imageView.image ?? UIImage() }
        set { imageView.image = newValue }
    }
    
    var value: String {
        get { amountLabel.text ?? "" }
        set { amountLabel.text = newValue }
    }
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let amountLabel = UILabel()
    
    init() {
        let blurEffect = UIBlurEffect(style: .light)
        super.init(effect: blurEffect)
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
            $0.textColor = .commonWhite
        }
        
        amountLabel.do {
            $0.font = .hakgyoansimDunggeunmisoBold_24
            $0.textColor = .commonWhite
        }
    }
    
    private func setLayout() {
        snp.makeConstraints {
            $0.height.equalTo(92)
        }
        
        imageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(20)
            $0.size.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.top)
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        amountLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func addSubView() {
        contentView.addSubviews(
            imageView,
            titleLabel,
            amountLabel
        )
    }
    
    func setValue(_ value: String) {
        amountLabel.text = value
    }
}
