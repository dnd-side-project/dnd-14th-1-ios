//
//  ChangeBadgeCollectionViewCell.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/17/26.
//

import UIKit
import Then
import SnapKit

final class ChangeBadgeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    private let currentBackgroundCircleView = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
    private let selectedBackgroundCircleView = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
    
    private let badgeImageView = UIImageView()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setLayout()
        setStyle()
        self.selectedBackgroundView = selectedBackgroundCircleView
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    func configure(badge: Badge) {
        badgeImageView.setImage(url: badge.imageUrl)
        currentBackgroundCircleView.isHidden = !badge.isCurrent
    }
    
    // MARK: - PrepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        badgeImageView.image = nil
    }
}

extension ChangeBadgeCollectionViewCell {
    
    private func addSubview() {
        [currentBackgroundCircleView, badgeImageView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setLayout() {
        badgeImageView.snp.makeConstraints {
            $0.edges.equalTo(contentView).inset(17)
        }
    }
    
    private func setStyle() {
        currentBackgroundCircleView.do {
            $0.backgroundColor = UIColor(hexCode: "EDEDED")
            $0.layer.cornerRadius = 45
            $0.clipsToBounds = true
        }
        
        selectedBackgroundCircleView.do {
            $0.backgroundColor = UIColor(hexCode: "ECF8FF")
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.primary500.cgColor
            $0.layer.cornerRadius = 45
            $0.clipsToBounds = true
        }
        
        badgeImageView.do {
            $0.contentMode = .scaleAspectFit
        }
    }
}
