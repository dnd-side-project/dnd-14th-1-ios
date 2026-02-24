//
//  PromptInputView.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/16/26.
//

import UIKit
import Combine

import SnapKit
import Then

enum PromptInputType {
    case text
    case url
}

struct PromptInput {
    let type: PromptInputType
    let value: String
}

class PromptInputView: UIView {
    private let topIndicator = UIView()
    private let textInputButton = AppChipButton(title: "텍스트 입력")
    private let urlLinkButton = AppChipButton(title: "URL 링크")
    private let buttonStackView = UIStackView()
    private let containerView = UIView()
    private let textView = UITextView()
    private let submitButton = UIButton()
    private let placeholderText = "AI에게 묻고싶은 프롬프트 내용을 직접 타이핑하여 진단 결과를 확인해보세요."
    private let placeholderUrl = "복사한 프롬프트 URL을 붙여넣어 진단 결과를 확인해보세요."
    private let promptInputType = CurrentValueSubject<PromptInputType, Never>(.text)
    
    private var subscriptions: Set<AnyCancellable> = []
    
    var onSubmit: ((PromptInput) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubView()
        setLayout()
        setStyle()
        addTargets()
        setDelegate()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        promptInputType
            .sink { [weak self] promptType in
                switch promptType {
                case .text:
                    self?.setTextInputButton()
                case .url:
                    self?.setUrlLinkButton()
                }
                self?.setPlaceholder()
            }
            .store(in: &subscriptions)
    }
    
    private func setDelegate() {
        textView.delegate = self
    }
    
    private func addSubView() {
        containerView
            .addSubviews(
                textView,
                submitButton
            )
        addSubviews(
            topIndicator,
            buttonStackView,
            containerView
        )
        
        buttonStackView
            .addArrangedSubviews(
                textInputButton,
                urlLinkButton
            )
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
    
    private func addTargets() {
        textInputButton.addTarget(self, action: #selector(promptTextButtonTapped), for: .touchUpInside)
        urlLinkButton.addTarget(self, action: #selector(urlLinkButtonTapped), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    private func setTextInputButton () {
        textInputButton.isSelected = true
        urlLinkButton.isSelected = false
    }
    
    private func setUrlLinkButton () {
        textInputButton.isSelected = false
        urlLinkButton.isSelected = true
    }
    
    @objc private func promptTextButtonTapped() {
        promptInputType.send(.text)
    }
    
    @objc private func urlLinkButtonTapped() {
        promptInputType.send(.url)
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
            $0.isEnabled = false
        }
        
        textInputButton.do {
            $0.isSelected = true
        }
    }
    
    private func setPlaceholder() {
        if textView.text == placeholderText || textView.text == placeholderUrl || textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            switch promptInputType.value {
            case .text:
                textView.text = placeholderText
            case .url:
                textView.text = placeholderUrl
            }
            textView.textColor = .gray200
        }
    }
    
    @objc private func submitButtonTapped() {        
        onSubmit?(.init(type: promptInputType.value, value: textView.text))
    }
}

extension PromptInputView: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        setPlaceholder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText || textView.text == placeholderUrl {
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
