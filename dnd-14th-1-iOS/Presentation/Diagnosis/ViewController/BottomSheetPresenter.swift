//
//  BottomSheetPresenter.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/16/26.
//

import UIKit

import SnapKit

class BottomSheetPresenter: UIViewController {
    private var maxY: CGFloat = 0
    private var parentHeight: CGFloat = 0
    private var sheetHeight: CGFloat = 0
    
    var onDissmiss: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGesture()        
    }
    
    private func setGesture() {
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handleGesture(_:))
        )
        view.addGestureRecognizer(panGesture)
    }
    
    func present(on parent: UIViewController, contentView: UIView, height: CGFloat) {
        parent.addChild(self)
        parent.view.addSubview(view)
        didMove(toParent: parent)
        
        parentHeight = parent.view.frame.height
        sheetHeight = height
        
        view.addSubview(contentView)
        
        view.frame = CGRect(
            x: 0,
            y: parent.view.frame.height,
            width: parent.view.frame.width,
            height: contentView.frame.height
        )
        
        maxY = parentHeight - height
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 0.8) {
            self.view.frame.origin.y = parent.view.frame.height - height
        }
    }
    
    @objc private func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            let newY = view.frame.origin.y + translation.y
            view.frame.origin.y = max(newY, maxY)
            gesture.setTranslation(.zero, in: view)
        case .ended:
            let positionY = view.frame.origin.y
            let dismissPosition = maxY + (sheetHeight * 0.3)
            
            if positionY > dismissPosition {
                dismissSheet()
            } else {
                restoreSheet()
            }
        default:
            break
        }
    }
    
    private func restoreSheet() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 0.8) {
            self.view.frame.origin.y = self.maxY
        }
    }
    
    private func dismissSheet() {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = self.parentHeight
        }
        onDissmiss?()
    }
}

// 제스처 추가
// 핸들바 터치다운 => 바텀시트 내려감
//
