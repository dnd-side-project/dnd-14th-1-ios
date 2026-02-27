//
//  MyBadgesCollectionView.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/17/26.
//

import UIKit
import Combine
import Then

final class MyBadgesCollectionView: UICollectionView {
    
    // MARK: - Properties
    let didTapBadgePublisher = PassthroughSubject<Badge, Never>()
    private var badges: [Badge] = []
    
    // MARK: - Initializer
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 90, height: 120)
        layout.minimumLineSpacing = 0
        super.init(frame: .zero, collectionViewLayout: layout)
        setDelegate()
        setCollectionView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = (self.bounds.width - 90 * 3) / 2
        }
    }
    
    func configure(badges: [Badge]) {
        self.badges = badges
        reloadData()
    }
}
    
extension MyBadgesCollectionView {
    
    private func setDelegate() {
        dataSource = self
        delegate = self
    }
    
    private func setCollectionView() {
        allowsSelection = true
        register(MyBadgesCollectionViewCell.self, forCellWithReuseIdentifier: MyBadgesCollectionViewCell.identifier)
    }
}

extension MyBadgesCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBadgesCollectionViewCell.identifier, for: indexPath) as? MyBadgesCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(badge: badges[indexPath.row])
        return cell
    }
}

extension MyBadgesCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let badge = badges[indexPath.row]
        didTapBadgePublisher.send(badge)
    }
}
