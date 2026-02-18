//
//  UIVisualEffect+.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/18/26.
//

import UIKit

final class CustomUIVisualEffectView: UIVisualEffectView {
    private var animator: UIViewPropertyAnimator?
    
    init(effect: UIVisualEffect?, intensity: CGFloat) {
        super.init(effect: nil)
        
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [weak self] in
            self?.effect = effect
        }
        
        animator?.fractionComplete = intensity
        animator?.pausesOnCompletion = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
