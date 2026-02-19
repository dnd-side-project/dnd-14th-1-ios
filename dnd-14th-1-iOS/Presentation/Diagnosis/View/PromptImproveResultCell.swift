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
    let result: String
}

final class PromptImproveResultCell: UICollectionViewCell {
    
    private let titleLabel = UILabel()
    private let divider = UIView()
    private let scrollView = UIScrollView()
    private let resultTextView = UITextView()
    
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
            $0.text = """
            export default function GeneratedLayout() { return ( <div className="min-h-screen bg-gray-50 flex items-center justify-center p-8"> {/* Main Container (Object 1) - Inferred: Main Card / Hero Section Wrapper - Style: White background, border, rounded corners - Layout: Flex column to manage vertical spacing naturally */} <div className="w-full max-w-[700px] min-h-[500px] bg-white border border-gray-200 rounded-xl shadow-sm flex flex-col justify-end p-10 relative overflow-hidden"> {/* Visual Placeholder for Top Area - Since the content (Gray Box) is at the bottom (y=320), the top area (y=50 to y=320) is likely an image or empty space. */} <div className="absolute top-0 left-0 w-full h-[55%] bg-gradient-to-b from-white to-gray-50 flex items-center justify-center text-gray-300"> <span className="text-sm font-medium">이미지 영역 (Placeholder)</span> </div> {/* Content Group (Object 4) - Inferred: Hero Content / Call to Action Box - Logic: Contains the Title and Button. - Restructuring: Converted absolute positioning to a relative Flex container. - Alignment: Centered horizontally (mx-auto) for better aesthetics than the raw coordinates. */} <div className="relative z-10 w-full max-w-[470px] bg-gray-100 rounded-xl p-8 flex flex-col items-center text-center gap-6 mx-auto shadow-sm"> {/* Hero Title (Object 2) - Inferred: Main Heading - Style: Bold, Large text */} <h2 className="text-3xl font-bold text-gray-900 leading-tight"> 새로운 가능성을 발견하세요 </h2> {/* Action Button (Object 3) - Inferred: Primary CTA
            """
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
    
    func configure(with result: PromptResult) {
        
    }
}


