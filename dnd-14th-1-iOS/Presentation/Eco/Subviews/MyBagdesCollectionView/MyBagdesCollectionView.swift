//
//  MyBagdesCollectionView.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/17/26.
//

import UIKit
import Combine
import Then

final class MyBagdesCollectionView: UICollectionView {
    
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
    
extension MyBagdesCollectionView {
    
    private func setDelegate() {
        dataSource = self
        delegate = self
    }
    
    private func setCollectionView() {
        allowsSelection = false
        register(MyBagdesCollectionViewCell.self, forCellWithReuseIdentifier: MyBagdesCollectionViewCell.identifier)
    }
}

extension MyBagdesCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBagdesCollectionViewCell.identifier, for: indexPath) as? MyBagdesCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(badge: badges[indexPath.row])
        return cell
    }
}

extension MyBagdesCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let badge = badges[indexPath.row]
        didTapBadgePublisher.send(badge)
    }
}
