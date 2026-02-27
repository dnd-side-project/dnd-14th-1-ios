//
//  PassthroughView.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/27/26.
//

import UIKit

final class PassThroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        // 터치된 뷰가 PassThroughView 자신(빈 바탕)이라면 이벤트를 무시(nil 반환)
        if hitView == self {
            return nil
        }
        
        // 그 외에 childVC 위에 올려둔 다른 버튼 등의 subview를 터치했다면 정상적으로 이벤트 전달
        return hitView
    }
}
