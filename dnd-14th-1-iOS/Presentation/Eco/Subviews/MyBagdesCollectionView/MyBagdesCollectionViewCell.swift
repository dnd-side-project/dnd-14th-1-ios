//
//  MyBagdesCollectionViewCell.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/17/26.
//

import UIKit
import Then
import SnapKit

final class MyBagdesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    private let badgeImageView = UIImageView()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setLayout()
        setStyle()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    func configure(badge: Badge) {
        badgeImageView.setImage(url: badge.imageUrl)
    }
    
    // MARK: - PrepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        badgeImageView.image = nil
    }
}

extension MyBagdesCollectionViewCell {
    
    private func addSubview() {
        [badgeImageView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setLayout() {
        badgeImageView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
    
    private func setStyle() {
        badgeImageView.do {
            $0.contentMode = .scaleAspectFit
        }
    }
}
