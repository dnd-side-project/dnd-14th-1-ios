//
//  ChangeBadgeCollectionView.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/17/26.
//

import UIKit
import Combine
import Then

final class ChangeBadgeCollectionView: UICollectionView {
    
    // MARK: - Properties
    let didSelectBadgePublisher = PassthroughSubject<Void, Never>()
    private var badges: [Badge] = []
    var selectedBadgeId: Int? {
        if let selectedIndexPath = indexPathsForSelectedItems?.first {
            return badges[selectedIndexPath.row].id
        }
        return nil
    }
    
    // MARK: - Initializer
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 90, height: 90)
        layout.minimumLineSpacing = 16
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
    
extension ChangeBadgeCollectionView {
    
    private func setDelegate() {
        dataSource = self
        delegate = self
    }
    
    private func setCollectionView() {
        allowsSelection = true
        allowsMultipleSelection = false
        register(ChangeBadgeCollectionViewCell.self, forCellWithReuseIdentifier: ChangeBadgeCollectionViewCell.identifier)
    }
}

extension ChangeBadgeCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChangeBadgeCollectionViewCell.identifier, for: indexPath) as? ChangeBadgeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(badge: badges[indexPath.row])
        return cell
    }
}

extension ChangeBadgeCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectBadgePublisher.send()
    }
}
