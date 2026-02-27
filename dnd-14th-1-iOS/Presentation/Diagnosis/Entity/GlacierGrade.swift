//
//  GlacierGrade.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/28/26.
//

import UIKit

struct GlacierGrade {
    let grade: Int
    
    var imageName: String {
        switch self.grade {
        case 1...5:
            "glacier_\(grade)"
        default:
            ""
        }
    }
}

struct GlacierGradeAnimation {
    let currentGrade: Int
    let isEfficiency: Bool
    
    var animationGrade: Int {
        if currentGrade == 1 && !isEfficiency { return 5 }
        if currentGrade == 5 && isEfficiency { return 2 }
        return max(2, 6 - currentGrade)
    }
    
    var isPlay: Bool {
        !(currentGrade == 1 && !isEfficiency)
    }
    
    var progress: (fromProgress: Double, toProgress: Double) {
        isEfficiency ? (1.0, 0.0) : (0.0, 1.0)
    }
}
