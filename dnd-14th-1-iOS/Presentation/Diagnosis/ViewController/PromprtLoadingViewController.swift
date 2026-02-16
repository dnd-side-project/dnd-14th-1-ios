//
//  PromprtLoadingViewController.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/15/26.
//

import UIKit

import SnapKit
import Then

final class PromprtLoadingViewController: BaseViewController {
    
    enum PromptLoadingType {
        case diagnose
        case imporve
    }
    
    private let loadingType: PromptLoadingType
    private let loadingView = UIImageView()
    private let loadingText = UILabel()
    private let loadingSubText = UILabel()
    
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
        startTask()
    }
    
    private func startTask() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            guard let self else { return }
            switch loadingType {
            case .diagnose:
                delegate?.didCompleteLoading(.diagnose)
            case .imporve:
                delegate?.didCompleteLoading(.imporve)
            }
        }
    }
    
    override func addSubview() {
        view.addSubviews(loadingView, loadingText, loadingSubText)
    }
    
    override func setStyle() {
        view.backgroundColor = .gray50
        
        loadingView.do {
            $0.image = UIImage(resource: .loading)
        }
        
        loadingText.do {
            $0.font = .title1_b
            $0.textColor = .gray800
        }
        
        loadingSubText.do {
            $0.font = .title3_r
            $0.textColor = .gray500
        }
    }
    
    override func setLayout() {
        loadingView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(237)
        }
        
        loadingText.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loadingView.snp.bottom).offset(24)
        }
        
        loadingSubText.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loadingText.snp.bottom).offset(12)
        }
    }
}
