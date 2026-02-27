//
//  PromptImproveSheetView.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/27/26.
//

import UIKit

import SnapKit
import Then

class PromptImproveSheetView: UIView {
    var onDismiss: (() -> Void)?
    
    private let prompt: PromptSentence
    private let titleLabel = UILabel()
    private let promptView = UIView()
    private let promptLabel = UILabel()
    private let improveReasonTitleLabel = CapsuleLabel()
    private let improveReasonLabel = UILabel()
    private let dismissButton = UIButton()
    private let improveReasonView = UIView()
    
    init(prompt: PromptSentence) {
         self.prompt = prompt
         super.init(frame: .zero)
         addSubView()
         setStyle()
         setLayout()
         addTargets()
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubView() {
        promptView.addSubview(promptLabel)
        
        addSubviews(
            titleLabel,
            promptView,
            improveReasonTitleLabel,
            improveReasonLabel,
            dismissButton
        )
    }
    
    private func setStyle() {
        backgroundColor = .white
        
        dismissButton.do {
            $0.setImage(UIImage(resource: .xMark), for: .normal)
        }
        
        titleLabel.do {
            $0.text = "수정 프롬프트 상세 보기"
            $0.font = .title2_b
            $0.textColor = .gray900
        }
        
        promptLabel.do {
            $0.text = prompt.originalPrompt
            $0.font = .body1_m
            $0.textColor = .commonWhite
            $0.numberOfLines = 3
        }
        
        improveReasonTitleLabel.do {
            $0.text = "수정한 이유는?"
            $0.font = .title3_b
            $0.textColor = .gray600
            $0.backgroundColor = .primary100
        }
        
        improveReasonLabel.do {
            $0.font = .body1_r
            $0.textColor = .gray900
            $0.text = prompt.reason
            $0.numberOfLines = 0
        }
        
        promptView.do {
            $0.backgroundColor = .negativeDarkbg
            $0.layer.cornerRadius = 8
        }
    }
    
    private func setLayout() {
        dismissButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(32)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
        }
        
        promptView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(26)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        promptLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
        
        improveReasonTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalTo(promptView.snp.bottom).offset(24)
        }
        
        improveReasonLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(improveReasonTitleLabel.snp.bottom).offset(12)
        }
    }
    
    private func addTargets() {
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    @objc private func dismissButtonTapped() {
        onDismiss?()
    }
}

final class CapsuleLabel: UILabel {
        
    var edgeInsets: UIEdgeInsets = .init(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: edgeInsets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        
        return CGSize(width: size.width + edgeInsets.left + edgeInsets.right,
                      height: size.height + edgeInsets.top + edgeInsets.bottom)
    }

    override var bounds: CGRect {
        didSet {
            preferredMaxLayoutWidth = bounds.width - (edgeInsets.left + edgeInsets.right)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }
}
