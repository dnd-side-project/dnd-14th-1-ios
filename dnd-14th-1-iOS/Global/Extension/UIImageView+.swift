//
//  UIImageView+.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/17/26.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    enum CacheOption {
        case none
        case memoryOnly
        case BothMemoryAndDisk
    }
    
    func setImage(url: String, _ cacheOption: CacheOption = .BothMemoryAndDisk) {
        
        guard let url = URL(string: url) else {
            return
        }
        
        var options: KingfisherOptionsInfo = [.transition(.fade(0.2))]
        
        switch cacheOption {
        case .none:
            break
        case .memoryOnly:
            options.append(.cacheMemoryOnly)
        case .BothMemoryAndDisk:
            options.append(.cacheOriginalImage)
        }
        
        self.kf.setImage(with: url, options: options)
    }
}
