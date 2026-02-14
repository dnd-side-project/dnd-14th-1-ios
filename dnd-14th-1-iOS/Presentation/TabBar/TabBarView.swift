//
//  TabBarView.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/14/26.
//

import UIKit

final class TabBarView: UITabBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addShadow()
    }
    
    private func addShadow() {
         layer.shadowColor = UIColor.gray300.cgColor
         layer.shadowOpacity = 0.15
         layer.shadowOffset = CGSize(width: 0, height: -8)
         layer.shadowRadius = 4
         layer.masksToBounds = false
     }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 108
        return size
    }
}
