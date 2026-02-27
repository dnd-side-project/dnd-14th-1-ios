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
