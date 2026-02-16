//
//  PromptView.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/16/26.
//

import UIKit

import SnapKit
import Then

class PromptView: UIView {
    private let titleLabel = UILabel()
    private let promptTextView = UITextView()
    private let dividerView = UIView()
    
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
        self.backgroundColor = .white
        layer.cornerRadius = 56
        
        titleLabel.do {
            $0.font = .title2_b
            $0.textColor = .gray600
            $0.text = "작성한 프롬프트"
        }
        
        dividerView.do {
            $0.backgroundColor = .gray100
        }
        
        promptTextView.do {
            $0.backgroundColor = .white
            $0.font = .body1_r
            $0.textColor = .gray900
        }
    }
    
    private func addSubview() {
        addSubviews(
            titleLabel,
            dividerView,
            promptTextView
        )
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(26)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(26)
            $0.height.equalTo(1)
        }
        
        promptTextView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(26)
            $0.height.equalTo(502)
            $0.bottom.equalToSuperview().inset(26)
        }
    }
}
