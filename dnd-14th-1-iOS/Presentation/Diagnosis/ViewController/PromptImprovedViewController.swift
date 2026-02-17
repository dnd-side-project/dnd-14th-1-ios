//
//  PromptImprovedViewController.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/17/26.
//

import UIKit

import SnapKit
import Then

class PromptImprovedViewController: BaseViewController {
    
    private enum Const {
        static let itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 400)
        static let itemSpacing = 12
    }
    
    private let imageView = UIImageView()
    private let bubbleImageView = UIImageView()
    private let savedTokenLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let buttonStackView = UIStackView()
    private let promptCopyButton = AppButton(size: .large, title: "프롬프트 복사하기", image: UIImage(resource: .copySimple))
    private let homeButton = UIButton()
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = Const.itemSize
        $0.minimumLineSpacing = 16
        $0.minimumInteritemSpacing = 0
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setStyle() {
        view.backgroundColor = .white
        
        imageView.do {
            $0.image = UIImage(resource: .improveResult)
        }
        
        bubbleImageView.do {
            $0.image = UIImage(resource: .chatBubble)
        }
        
        titleLabel.do {
            $0.font = .headline3_b
            $0.textColor = .gray900
            $0.text = "성공적인 구조 작업!\n북극곰의 발판이 더 단단해졌어요"
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        subtitleLabel.do {
            $0.font = .body2_b
            $0.textColor = .gray500
            $0.text = "카드를 넘겨 수정이 완료된 프롬프트를 확인해보세요"
            
        }
        
        buttonStackView.do {
            $0.spacing = 12
        }
        
        homeButton.do {
            $0.setImage(UIImage(resource: .homeButton), for: .normal)
        }
        
        promptCopyButton.do {
            $0.addTarget(self, action: #selector(promptCopyButtonTapped), for: .touchUpInside)
        }
        
        collectionView.do {
            $0.isScrollEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = true
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
            $0.register(PromptImproveResultCell.self, forCellWithReuseIdentifier: PromptImproveResultCell.identifier)
            $0.isPagingEnabled = false
            $0.contentInsetAdjustmentBehavior = .never
            $0.decelerationRate = .fast
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        
        configureSavedTokenLabel()
    }
    
    private func configureSavedTokenLabel() {
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(
            string: "79",
            attributes: [
                .font: UIFont.hakgyoansimDunggeunmisoBold_16,
                .foregroundColor: UIColor.positiveDarkbg
            ]
        ))
        
        attributedString.append(NSAttributedString(
            string: "개",
            attributes: [
                .font: UIFont.hakgyoansimDunggeunmisoRegular_14,
                .foregroundColor: UIColor.positiveDarkbg
            ]
        ))
        
        attributedString.append(NSAttributedString(
            string: "의\n토큰을 아꼈어요",
            attributes: [
                .font: UIFont.label2_m,
                .foregroundColor: UIColor.white
            ]
        ))
        
        savedTokenLabel.numberOfLines = 0
        savedTokenLabel.attributedText = attributedString
    }
    
    override func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func addSubview() {
        bubbleImageView.addSubview(savedTokenLabel)
        
        buttonStackView.addArrangedSubviews(
            promptCopyButton,
            homeButton
        )
        
        view.addSubviews(
            imageView,
            bubbleImageView,
            titleLabel,
            subtitleLabel,
            collectionView,
            buttonStackView
        )
    }
    
    override func setLayout() {
        imageView.snp.makeConstraints {
            $0.top.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        savedTokenLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(14)
        }
        
        bubbleImageView.snp.makeConstraints {
            $0.top.equalTo(imageView)
            $0.leading.equalTo(imageView.snp.trailing)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(22)
            $0.height.equalTo(440)
            $0.horizontalEdges.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-5)
        }
        
        homeButton.snp.makeConstraints {
            $0.width.equalTo(68)
            $0.height.equalTo(60)
        }
        
        collectionView.backgroundColor = .red
    }
}


extension PromptImprovedViewController {
    @objc private func promptCopyButtonTapped() {}
}


extension PromptImprovedViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let itemWidth = Const.itemSize.width + collectionViewFlowLayout.minimumLineSpacing
        
        let offsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let index = round(offsetX / itemWidth)
        
        let maxIndex = CGFloat(collectionView.numberOfItems(inSection: 0) - 1)
        let clampedIndex = max(0, min(index, maxIndex))        
        targetContentOffset.pointee.x = clampedIndex * itemWidth - scrollView.contentInset.left
    }
}

extension PromptImprovedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PromptImproveResultCell.identifier,
            for: indexPath
        ) as? PromptImproveResultCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}
