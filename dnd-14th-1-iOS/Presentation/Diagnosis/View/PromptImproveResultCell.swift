//
//  ImproveCollectionViewCell.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/17/26.
//

import UIKit

import SnapKit
import Then

struct PromptResult {
    let isImprove: Bool
    let text: String
    let sentences: [PromptSentence]
}

final class PromptImproveResultCell: UICollectionViewCell {
    
    var action: ((PromptSentence) -> Void)?
    
    private let titleLabel = UILabel()
    private let divider = UIView()
    private let scrollView = UIScrollView()
    private let resultTextView = UITextView()
    private var promptResult = PromptResult(isImprove: false, text: "", sentences: [])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setStyle()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        contentView.backgroundColor = .gray100
        contentView.layer.cornerRadius = 28
        
        titleLabel.do {
            $0.font = .title1_b
            $0.text = "수정이 필요했어요"
            $0.textColor = .negativeDarkbg
        }
        
        divider.do {
            $0.backgroundColor = .gray200
        }
        
        resultTextView.do {
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .gray100
            $0.font = .body1_r
            $0.textColor = .gray500
        }
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(24)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(1)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
        
        resultTextView.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide)
            $0.width.height.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalTo(scrollView.contentLayoutGuide)
        }
    }
    
    private func addSubview() {
        scrollView.addSubview(resultTextView)
        contentView.addSubviews(titleLabel, divider, scrollView)
    }
    
    func configure(with prompt: PromptResult) {
        self.promptResult = prompt
        resultTextView.text = promptResult.text
        if promptResult.isImprove {
            contentView.backgroundColor = .primary100
            resultTextView.backgroundColor = .primary100
            resultTextView.textColor = .gray800
            titleLabel.text = "이렇게 수정했어요"
            titleLabel.textColor = .primary500
            divider.backgroundColor = .primary300
        }
        
        let text = prompt.text
        let attributed = NSMutableAttributedString(
            attributedString: resultTextView.attributedText ?? NSAttributedString(string: text)
        )
        
        for (index, sentence) in prompt.sentences.enumerated() {
            let nsRange = NSRange(sentence.improvementRange, in: text)
            
            attributed.addAttribute(
                .backgroundColor,
                value: UIColor(hexCode: "#EEB1B0").withAlphaComponent(0.7),
                range: nsRange
            )
            
            attributed.addAttribute(
                .link,
                value: "action://sentence/\(index)",
                range: nsRange
            )
        }
        
        resultTextView.attributedText = attributed
        resultTextView.isEditable = false
        resultTextView.delegate = self
    }
}

extension PromptImproveResultCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        guard URL.scheme == "action",
              URL.host == "sentence",
              let indexString = URL.pathComponents.last,
              let index = Int(indexString),
              promptResult.sentences.indices.contains(index)
        else { return false }
        
        let sentence = promptResult.sentences[index]
        action?(sentence)
        return false
    }
}


