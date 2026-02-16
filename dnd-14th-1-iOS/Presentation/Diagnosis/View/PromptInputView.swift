//
//  PromptInputView.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/16/26.
//

import UIKit

import SnapKit
import Then

class PromptInputView: UIView {
    private let topIndicator = UIView()
    private let textInputButton = AppChipButton(title: "텍스트 입력")
    private let urlLinkButton = AppChipButton(title: "URL 링크")
    private let buttonStackView = UIStackView()
    private let containerView = UIView()
    private let textView = UITextView()
    private let submitButton = UIButton()
    private let placeholderText = "AI에게 묻고싶은 프롬프트 내용을 직접 타이핑하여 진단 결과를 확인해보세요."
    
    var buttonTapped: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubView()
        setLayout()
        setStyle()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDelegate() {
        textView.delegate = self
    }
    
    private func addSubView() {
        containerView.addSubviews(textView, submitButton)
        addSubviews(topIndicator, buttonStackView, containerView)
        
        [textInputButton, urlLinkButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
    }
    
    private func setLayout() {
        topIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(16)
            $0.width.equalTo(80)
            $0.height.equalTo(5)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topIndicator.snp.bottom).offset(16)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(426)
        }
        submitButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(16)
        }
        textView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(submitButton.snp.top).offset(10)
        }
    }
    
    private func setStyle() {
        backgroundColor = .primary400
        layer.cornerRadius = 56
        
        textView.do {
            $0.font = .body1_m
            $0.textColor = .gray200
            $0.text = placeholderText
            $0.backgroundColor = .white
        }
        
        topIndicator.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 3
        }
        
        buttonStackView.do {
            $0.spacing = 12
            $0.backgroundColor = .gray50
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            $0.layer.cornerRadius = 26
        }
        
        containerView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 56
            $0.clipsToBounds = true
        }
        
        submitButton.do {
            $0.setImage(UIImage(resource: .button), for: .normal)
            $0.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        }
    }
    
    @objc private func submitButtonTapped() {
        buttonTapped?(textView.text)
    }
}

extension PromptInputView: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholderText
            textView.textColor = .gray200
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = nil
            textView.textColor = .gray600
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let hasText = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        submitButton.setImage(UIImage(resource: hasText ? .buttonActive : .button), for: .normal)
        submitButton.isEnabled = hasText
    }
}
