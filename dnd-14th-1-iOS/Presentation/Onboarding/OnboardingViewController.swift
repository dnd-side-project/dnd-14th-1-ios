//
//  OnboardingViewController.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/6/26.
//

import UIKit
import Combine
import Then
import SnapKit

final class OnboardingViewController: BaseViewController {
    
    // MARK: - Properties
    private var subscriptions: Set<AnyCancellable> = []
    
    private let items: [OnboardingItem] = [
        OnboardingItem(
            title: "프롬프트 입력",
            description: "내가 쓰고 있는 프롬프트를\n진단받을 수 있어요",
            image: UIImage.onboarding1
        ),
        OnboardingItem(
            title: "프롬프트 체크",
            description: "비효율적인 프롬프트를 입력하면\n빙하 상태가 변경돼요",
            image: UIImage.onboarding2
        ),
        OnboardingItem(
            title: "프롬프트 수정",
            description: "불필요한 내용을 수정 받아\n빙하를 더 단단하게 만들어요",
            image: UIImage.onboarding3
        ),
        OnboardingItem(
            title: "뱃지 수집",
            description: "올바른 프롬프트로 빙하를 지킨만큼\n뱃지를 가질 수 있어요",
            image: UIImage.onboarding4
        )
    ]
    
    // MARK: - UI Components
    private let onboardingPageControl = OnboardingPageControl()
    
    private lazy var onboardingCollectionView = OnboardingCollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).then {
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.isHidden = true
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = UIFont.title1_b
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.backgroundColor = UIColor.primary900
    }
    
    private let paddingView = UIView().then {
        $0.backgroundColor = UIColor.primary900
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        onboardingCollectionView.configure(items)
        onboardingPageControl.numberOfPages = items.count
        bind()
        setAddTarget()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if onboardingCollectionView.isHidden {
            onboardingCollectionView.collectionViewLayout = UICollectionViewFlowLayout().then {
                $0.itemSize = CGSize(width: view.frame.width, height: view.safeAreaLayoutGuide.layoutFrame.height - 88 - 56)
                $0.minimumLineSpacing = 0
                $0.scrollDirection = .horizontal
            }
            onboardingCollectionView.isHidden = false
        }
    }
    
    // MARK: - Base
    override func addSubview() {
        [onboardingPageControl, onboardingCollectionView, nextButton, paddingView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        onboardingPageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(54)
            $0.height.equalTo(8)
        }
        
        onboardingCollectionView.snp.makeConstraints {
            $0.top.equalTo(onboardingPageControl.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        paddingView.snp.makeConstraints {
            $0.top.equalTo(nextButton.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension OnboardingViewController {
    
    func bind() {
        onboardingCollectionView.pageChangedPublisher.sink { [weak self] page in
            self?.onboardingPageControl.currentPage = page
        }.store(in: &subscriptions)
        
        onboardingPageControl.lastPagePublisher.sink { [weak self] isLast in
            self?.nextButton.setTitle(isLast ? "시작하기" : "다음", for: .normal)
        }.store(in: &subscriptions)
    }
    
    func setAddTarget() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func nextButtonTapped(_ sender: UIButton) {
        
        if onboardingPageControl.currentPage == onboardingPageControl.numberOfPages - 1 {
//            let viewController = HomeTabbarController()
//            navigationController?.setViewControllers([viewController], animated: true)
            return
        }
        
        let indexPath = IndexPath(item: onboardingPageControl.currentPage + 1, section: 0)
        onboardingCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }
}
