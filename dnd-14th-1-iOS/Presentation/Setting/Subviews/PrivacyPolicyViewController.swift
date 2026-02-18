//
//  PrivacyPolicyViewController.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/18/26.
//

import UIKit
import Then
import SnapKit

final class PrivacyPolicyViewController: BaseViewController {
    
    // MARK: - Properties
    private let appName = "saving(세이빙)"
    private let name = "이름"
    private let email = "exmaple@domain.com"
    
    private lazy var privacyPolicy = """
        \(appName)(이하 "서비스")은 이용자의 개인정보를 중요시하며, "개인정보보호법" 및 "정보통신망 이용촉진 및 정보보호 등에 관한 법률"을 준수하고 있습니다.

        1. 수집하는 개인정보 항목
        "서비스"는 별도의 회원가입 절차 없이 이용 가능한 경우 정보를 수집하지 않으나, 기능 제공을 위해 아래 정보를 수집할 수 있습니다.
        - 수집 항목: [예: 기기 모델명, OS 버전, 푸시 토큰, 이메일 주소(문의 시)]
        - 수집 방법: 앱 실행 시 자동 수집 혹은 사용자 직접 입력

        2. 개인정보의 수집 및 이용목적
        수집된 정보는 다음의 목적을 위해서만 활용됩니다.
        - 서비스 제공 및 기능 최적화
        - 사용자 문의에 대한 응대 및 기술지원

        3. 개인정보의 보유 및 이용기간
        이용자의 개인정보는 서비스 이용 목적이 달성된 후 지체 없이 파기합니다. 단, 관계법령의 규정에 의하여 보존할 필요가 있는 경우 일정 기간 보관합니다.

        4. 개인정보의 파기절차 및 방법
        전자적 파일 형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다.

        5. 제3자 제공 및 위탁
        "서비스"는 이용자의 개인정보를 원칙적으로 외부에 제공하지 않습니다. (Firebase, Sentry 등 분석 도구 사용 시 해당 내용 명시 필요)

        6. 이용자의 권리와 그 행사방법
        이용자는 언제든지 등록되어 있는 자신의 개인정보를 조회하거나 수정할 수 있으며 삭제를 요청할 수 있습니다.

        7. 개인정보 보호책임자
        서비스 이용 중 발생하는 모든 개인정보 보호 관련 민원은 아래의 책임자에게 문의하실 수 있습니다.
        - 성명/닉네임: \(name)
        - 이메일: \(email)

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
                string: "개인정보 처리방침",
                attributes: [
                    .font : UIFont.display2_b,
                    .foregroundColor : UIColor.gray900
                ])
        }
        
        descriptionLabel.do {
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineHeightMultiple = 1.50
            $0.numberOfLines = 0
            $0.attributedText = NSAttributedString(
                string: privacyPolicy,
                attributes: [
                    .font : UIFont.label1_r,
                    .foregroundColor : UIColor.gray900,
                    .paragraphStyle : paragraph
                ]
            )
        }
    }
}
