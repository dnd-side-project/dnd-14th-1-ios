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
        case bothMemoryAndDisk
    }
    
    func setImage(url: String) {
        
        guard let url = URL(string: url) else {
            return
        }
        
        let accessToken = KeychainWorker.shared.read(key: .access) ?? ""
        let modifier = AnyModifier { request in
            var modifiedRequest = request
            modifiedRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            return modifiedRequest
        }
        
        let options: KingfisherOptionsInfo = [
            .requestModifier(modifier),
            .transition(.fade(0.2)),
            .forceTransition,
            .cacheOriginalImage
        ]
        
        self.kf.setImage(with: url, options: options)
    }
}
