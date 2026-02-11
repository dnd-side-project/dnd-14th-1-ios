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
        
        descriptionLabel.font = UIFont.body1_r
        descriptionLabel.setTextWithLineHeight(text: item.description, lineHeight: 16 * 1.50)
        let mutableAttributedString = descriptionLabel.attributedText?.mutableCopy() as? NSMutableAttributedString
        mutableAttributedString?.addAttributes(
            [
                .font : UIFont.body1_r,
                .foregroundColor : UIColor.gray500
            ],
            range: NSRange(location: 0, length: item.description.count)
        )
        descriptionLabel.attributedText = mutableAttributedString
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center
        
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
