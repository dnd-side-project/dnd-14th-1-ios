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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubView()
        setLayout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubView() {
        addSubviews(topIndicator)
    }
    
    private func setLayout() {
        topIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(16)
            $0.width.equalTo(80)
            $0.height.equalTo(5)
        }
    }
    
    private func setStyle() {
        backgroundColor = .primary400
        layer.cornerRadius = 56
        
        topIndicator.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 3
        }
    }    
}
