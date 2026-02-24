//
//  TermsOfUseViewController.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/18/26.
//

import UIKit
import Then
import SnapKit

final class TermsOfUseViewController: BaseViewController {
    
    // MARK: - Properties
    private let appName = "saving(세이빙)"
    
    private lazy var termsOfUse = """
        제1조 (목적)
        본 약관은 \(appName)(이하 "서비스")이 제공하는 관련 제반 서비스의 이용과 관련하여 "서비스"와 이용자의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.

        제2조 (용어의 정의)
        1. "서비스"라 함은 \(appName) 앱을 통해 이용자에게 제공되는 기능을 의미합니다.
        2. "이용자"란 "서비스"에 접속하여 본 약관에 따라 서비스를 이용하는 자를 말합니다.

        제3조 (서비스의 제공 및 변경)
        1. "서비스"는 이용자에게 [주요 서비스 내용, 예: 데이터 기록 및 분석 기능]을 제공합니다.
        2. "서비스"는 운영상, 기술상의 필요에 따라 제공하고 있는 서비스의 전부 또는 일부를 변경할 수 있습니다.

        제4조 (이용자의 의무)
        이용자는 다음 행위를 하여서는 안 됩니다.
        1. 타인의 정보 도용
        2. "서비스"가 게시한 정보의 변경
        3. "서비스"가 금지한 정보(컴퓨터 프로그램 등)의 송신 또는 게시

        제5조 (책임의 제한)
        1. "서비스"는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임이 면제됩니다.
        2. "서비스"는 이용자의 귀책사유로 인한 서비스 이용의 장애에 대하여 책임을 지지 않습니다.

        제6조 (준거법 및 재판관할)
        본 약관과 관련하여 발생한 분쟁에 대해서는 대한민국 법령을 준거법으로 하며, 관할 법원은 민사소송법에 따릅니다.

        공고일자: 2026년 2월 15일
        시행일자: 2026년 2월 15일
        """
 
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexCode: "FAFAFA")
    }
    
    override func addSubview() {
        [titleLabel, descriptionLabel].forEach {
            contentView.addSubview($0)
        }
        [contentView].forEach {
            scrollView.addSubview($0)
        }
        [scrollView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(24)
            $0.leading.equalTo(contentView)
            $0.height.equalTo(32)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(contentView)
            $0.bottom.equalTo(contentView).offset(-24)
        }
    }
    
    override func setStyle() {
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        titleLabel.do {
            $0.attributedText = NSAttributedString(
                string: "이용약관",
                attributes: [
                    .font : UIFont.display2_b,
                    .foregroundColor : UIColor.gray900
                ]
            )
        }
        
        descriptionLabel.do {
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineHeightMultiple = 1.50
            $0.numberOfLines = 0
            $0.attributedText = NSAttributedString(
                string: termsOfUse,
                attributes: [
                    .font : UIFont.label1_r,
                    .foregroundColor : UIColor.gray900,
                    .paragraphStyle : paragraph
                ]
            )
        }
    }
}
