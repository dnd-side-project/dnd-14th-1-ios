//
//  PromptLoadingViewController.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/15/26.
//

import UIKit

import SnapKit
import Then
import Lottie

final class PromptLoadingViewController: BaseViewController {
    
    enum PromptLoadingType {
        case diagnose
        case improve
    }
    
    private let layoutGuide = UILayoutGuide()
    private let loadingType: PromptLoadingType
    private let animationView = LottieAnimationView(name: "loadinganimat")
    private let loadingText = UILabel()
    private let loadingSubText = UILabel()
    private let dummyView = UIView()
    
    weak var delegate: PromptLoadingViewControllerDelegate?
    
    init(title: String, description: String, loadingType: PromptLoadingType) {
        loadingText.text = title
        loadingSubText.text = description
        self.loadingType = loadingType
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func addSubview() {
        view.addSubviews(
            animationView,
            loadingText,
            loadingSubText,
            dummyView
        )
        view.addLayoutGuide(layoutGuide)
    }
    
    override func setStyle() {
        view.backgroundColor = .gray50
        
        animationView.do {
            $0.loopMode = .loop
            $0.play()
        }
        
        loadingText.do {
            $0.font = .title1_b
            $0.textColor = .gray800
        }
        
        loadingSubText.do {
            $0.font = .title3_r
            $0.textColor = .gray500
        }
        
        dummyView.do {
            $0.backgroundColor = .gray50
        }
    }
    
    override func setLayout() {
        layoutGuide.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        animationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(layoutGuide)
        }
        
        loadingText.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(animationView.snp.bottom).offset(24)
        }
        
        loadingSubText.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loadingText.snp.bottom).offset(12)
            $0.bottom.equalTo(layoutGuide)
        }
        
        dummyView.snp.makeConstraints {
            $0.trailing.bottom.equalTo(animationView)
            $0.height.equalTo(40)
            $0.width.equalTo(80)
        }
    }
}
