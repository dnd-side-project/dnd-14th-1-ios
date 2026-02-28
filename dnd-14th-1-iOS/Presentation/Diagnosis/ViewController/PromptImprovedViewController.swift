//
//  PromptImprovedViewController.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/17/26.
//

import UIKit
import Combine

import SnapKit
import Then
import Lottie

class PromptImprovedViewController: BaseViewController {
    
    private var itemSize = CGSize.zero
    private var itemSpacing: CGFloat = 12
    private var minimumLineSpacing: CGFloat = 16
    
    let viewModel: PromptImproveViewModel
    
    private let inputSubject = PassthroughSubject<PromptImproveViewModel.Input, Never>()
    private let animationView = LottieAnimationView(name: "lottie_finisheditor")
    private let bubbleImageView = UIImageView()
    private let savedTokenLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let buttonStackView = UIStackView()
    private let promptCopyButton = AppButton(size: .large, title: "프롬프트 복사하기", image: UIImage(resource: .copySimple))
    private let homeButton = UIButton()
    
    private let dummyView = UIView()
    
    weak var delegate: PromptImprovedViewControllerDelegate?
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var subscriptions: Set<AnyCancellable> = []
    private var prompts: [PromptResult] = []
    
    init(viewModel: PromptImproveViewModel) {
        self.viewModel = viewModel
        super.init()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject.receive(on: DispatchQueue.main).sink { [weak self] output in
            switch output {
            case let .showPromptImprovement(result):
                self?.configureSavedTokenLabel(result.savedToken)
                self?.showImprovedPrompt(result)
            case let .promptCopyCompleted(prompTextt):
                self?.copyImprovedPrompt(prompTextt)
            }
        }
        .store(in: &subscriptions)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputSubject.send(.viewDidLoad)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let flowlayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.scrollDirection = .horizontal
            flowlayout.itemSize = CGSize(width: collectionView.frame.width - 58, height: collectionView.frame.height)
            itemSize = CGSize(width: collectionView.frame.width - 58, height: collectionView.frame.height)
            flowlayout.minimumLineSpacing = minimumLineSpacing
            flowlayout.minimumInteritemSpacing = 0
            flowlayout.invalidateLayout()
        }
    }
    
    override func setStyle() {
        view.backgroundColor = .white
        
        animationView.do {
            $0.play()
            $0.loopMode = .loop
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
            $0.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
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
        
        dummyView.do {
            $0.backgroundColor = .white
        }
    }
    
    private func configureSavedTokenLabel(_ savedToken: Int) {
        if savedToken <= 0 {
            bubbleImageView.isHidden = true
            return
        }
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(
            string: "\(savedToken)",
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
            animationView,
            bubbleImageView,
            titleLabel,
            subtitleLabel,
            collectionView,
            buttonStackView,
            dummyView
        )
    }
    
    override func setLayout() {
        animationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.snp.centerX).offset(-80)
        }
        
        savedTokenLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(14)
        }
        
        bubbleImageView.snp.makeConstraints {
            $0.top.equalTo(animationView)
            $0.leading.equalTo(view.snp.centerX).offset(64)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(animationView.snp.bottom)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(22)
            $0.bottom.equalTo(buttonStackView.snp.top).offset(-30)
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
        
        dummyView.snp.makeConstraints {
            $0.trailing.bottom.equalTo(animationView)
            $0.height.equalTo(20)
            $0.width.equalTo(60)
        }
    }
}

// MARK: - Helper

extension PromptImprovedViewController {
    private func showImprovedPrompt(_ prompt: PromptImproveResult) {
        self.prompts = [
            PromptResult(isImprove: false, text: prompt.originalPrompt, sentences: prompt.sentences),
            PromptResult(isImprove: true, text: prompt.improvedPrompt, sentences: [])
        ]
        collectionView.reloadData()
    }
    
    private func presentImprovedPromptSheet(_ prompt: PromptSentence) {
        let bottomSheetViewController = UIViewController()
        let promptImproveSheetView = PromptImproveSheetView(prompt: prompt)
        bottomSheetViewController.view = promptImproveSheetView
        
        if let sheet = bottomSheetViewController.sheetPresentationController {
            sheet.detents = [
                .medium(),
                .custom(resolver: { context in
                    return context.maximumDetentValue - 1
                })
            ]
            sheet.prefersGrabberVisible = true
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.preferredCornerRadius = 56
        }
        
        promptImproveSheetView.onDismiss = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        present(bottomSheetViewController, animated: true)
    }
    
    private func copyImprovedPrompt(_ promptText: String) {
        UIPasteboard.general.string = promptText
        showToast(message: "프롬프트 복사가 완료되었어요!", type: .networkError)
    }
}


extension PromptImprovedViewController {
    @objc private func promptCopyButtonTapped() {
        inputSubject.send(.promptCopyButtonTapped)
    }
    
    @objc private func homeButtonTapped() {
        delegate?.promptHomeButtonTapped()
    }
}


extension PromptImprovedViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let itemWidth = itemSize.width + minimumLineSpacing
        
        let offsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let index = round(offsetX / itemWidth)
        
        let maxIndex = CGFloat(collectionView.numberOfItems(inSection: 0) - 1)
        let clampedIndex = max(0, min(index, maxIndex))
        targetContentOffset.pointee.x = clampedIndex * itemWidth - scrollView.contentInset.left
    }
}

extension PromptImprovedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        prompts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PromptImproveResultCell.identifier,
            for: indexPath
        ) as? PromptImproveResultCell else {
            return UICollectionViewCell()
        }
        let index = indexPath.row
        let isImprove = index > 0
        let prompt = PromptResult(isImprove: isImprove, text: prompts[index].text, sentences: prompts[index].sentences)
        cell.configure(with: prompt)
        cell.action = presentImprovedPromptSheet
        return cell
    }
}


