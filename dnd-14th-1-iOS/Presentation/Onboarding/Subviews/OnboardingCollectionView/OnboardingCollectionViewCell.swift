//
//  OnboardingCollectionViewCell.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/10/26.
//

import UIKit
import Then
import SnapKit

final class OnboardingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    private let titleLabel = UILabel().then {
        $0.font = UIFont.headline2_b
        $0.textColor = UIColor.gray800
    }
    private let descriptionLabel = UILabel()
    
    private let onboardingImageView = UIImageView()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ item: OnboardingItem) {
        titleLabel.text = item.title
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        paragraphStyle.alignment = .center
        
        descriptionLabel.attributedText = NSAttributedString(
            string: item.description,
            attributes: [
                .font : UIFont.body1_r,
                .foregroundColor : UIColor.gray500,
                .paragraphStyle : paragraphStyle
            ]
        )
        descriptionLabel.numberOfLines = 2
        
        onboardingImageView.image = item.image
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}

extension OnboardingCollectionViewCell {
    
    func addSubview() {
        [titleLabel, descriptionLabel, onboardingImageView].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        onboardingImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
