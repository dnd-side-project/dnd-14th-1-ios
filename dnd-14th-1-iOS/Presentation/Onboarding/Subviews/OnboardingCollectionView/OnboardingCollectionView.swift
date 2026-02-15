//
//  OnboardingCollectionView.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/10/26.
//

import UIKit
import Combine

final class OnboardingCollectionView: UICollectionView {
    
    // MARK: - Properties
    private var items: [OnboardingItem] = []
    let pageChangedPublisher = PassthroughSubject<Int, Never>()
    
    // MARK: - Initializer
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setCollectionView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCollectionView() {
        register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        dataSource = self
        delegate = self
    }
    
    func configure(_ items: [OnboardingItem]) {
        self.items = items
        reloadData()
    }
}

extension OnboardingCollectionView: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as? OnboardingCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(items[indexPath.row])
        return cell
    }
}

extension OnboardingCollectionView: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = frame.width
        let page = Int((contentOffset.x + width/2)/width)
        
        if 0 <= page, page <= items.count - 1 {
            pageChangedPublisher.send(page)
        }
    }
}
