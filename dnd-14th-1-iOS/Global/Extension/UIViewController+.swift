//
//  UIViewController+.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/17/26.
//

import UIKit
import Then
import SnapKit

extension UIViewController {
    
    func dismissKeyboardWhenTapAround() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    
    enum ToastType {
        case internalError
        case networkError
    }
    
    func showToast(message: String, type: ToastType) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }
        
        let toastImageView: UIImageView?
        let toastView = UIView().then {
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
            $0.alpha = 0
            $0.tag = 999
        }
        let toastLabel = UILabel().then {
            $0.font = UIFont.label2_b
            $0.text = message
            $0.textColor = .white
        }
        switch type {
        case .internalError:
            toastImageView = UIImageView(image: UIImage(systemName: "exclamationmark.circle"))
            toastImageView?.tintColor = .white
            toastView.backgroundColor = UIColor(hexCode: "FF4242")
        case .networkError:
            toastImageView = nil
            toastView.backgroundColor = UIColor(hexCode: "A1A1A1")
        }
        
        if let toastImageView {
            [toastImageView, toastLabel].forEach {
                toastView.addSubview($0)
            }
            toastImageView.snp.makeConstraints {
                $0.size.equalTo(20)
                $0.top.equalTo(toastView).offset(4)
                $0.leading.equalTo(toastView).offset(8)
            }
            toastLabel.snp.makeConstraints {
                $0.centerY.equalTo(toastView)
                $0.leading.equalTo(toastImageView.snp.trailing).offset(4)
                $0.trailing.equalTo(toastView).offset(-8)
            }
        } else {
            [toastLabel].forEach {
                toastView.addSubview($0)
            }
            toastLabel.snp.makeConstraints {
                $0.centerY.equalTo(toastView)
                $0.leading.trailing.equalTo(toastView).inset(12)
            }
        }
        
        window.viewWithTag(999)?.removeFromSuperview()
        window.addSubview(toastView)
        toastView.snp.makeConstraints {
            $0.height.equalTo(28)
            $0.bottom.equalTo(window.safeAreaLayoutGuide).offset(-24)
            $0.centerX.equalTo(window)
        }
        
        UIView.animate(
            withDuration: 0.25,
            animations: {
                toastView.alpha = 1
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.25,
                    delay: 3.0,
                    animations: {
                        toastView.alpha = 0
                    },
                    completion: { _ in
                        toastView.removeFromSuperview()
                    }
                )
            }
        )
    }
}
